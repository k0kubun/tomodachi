require 'yaml'
require 'oauth'
require 'thor'
require 'thor/group'
require 'twitter'

class Tomodachi::Auth < Thor::Group
  include Thor::Actions

  CONFIG_PATH = File.expand_path('~/.tomodachi/config.yml')

  def create
    consumer = OAuth::Consumer.new(
      CONSUMER_KEY,
      CONSUMER_SECRET,
      site: 'https://api.twitter.com'
    )
    request_token = consumer.get_request_token

    say request_token.authorize_url
    system 'open', request_token.authorize_url
    pin = ask 'PIN:'

    access_token = request_token.get_access_token(oauth_verifier: pin)

    Twitter.configure do |config|
      config.consumer_key = CONSUMER_KEY
      config.consumer_secret = CONSUMER_SECRET
      config.oauth_token = access_token.token
      config.oauth_token_secret = access_token.secret
    end
    user = Twitter.user

    conf = Array.new unless conf = Auth.load_config
    if Auth.exist_by_id?(user[:id])
      puts user[:screen_name] + ' is already added.'
    else
      conf += [
        id: user[:id],
        screen_name: user[:screen_name],
        access_token: access_token.token,
        access_token_secret: access_token.secret
      ]
      Auth.save_config(conf)
      puts 'Added configuration for ' + user[:screen_name]
    end
  end

  def self.list
    current_conf = Auth.load_config
    if current_conf
      current_conf.each do |conf|
        puts conf[:screen_name]
      end
    else
      puts "There is no authenticated account."
    end
  end

  def self.exist?(screen_name)
    if confs = Auth.load_config
      confs.each do |conf|
        if conf[:screen_name] == screen_name
          return true
        end
      end
    end
    false
  end

  def self.exist_by_id?(id)
    if confs = Auth.load_config
      confs.each do |conf|
        if conf[:id] == id
          return true
        end
      end
    end
    false
  end

  def self.load_config
    path = File.expand_path('~/.tomodachi/')
    if FileTest.exist?(path) == false
      FileUtils.mkdir_p(path)
      return nil
    end

    if FileTest.exist?(CONFIG_PATH)
      str = nil
      File.open(CONFIG_PATH, 'r') do |f|
        str = f.read
      end
      YAML.load(str)
    else
      nil
    end
  end

  def self.load_token(screen_name)
    str = nil
    File.open(CONFIG_PATH, 'r') do |f|
      str = f.read
    end

    if str
      conf_all = YAML.load(str)

      conf_all.each do |conf|
        if conf[:screen_name] == screen_name
          return conf
        end
      end
    else
      nil
    end
  end

  def self.save_config(conf)
    File.open(CONFIG_PATH, 'w') do |f|
      f << conf.to_yaml
    end
  end
end
