require 'yaml'
require 'oauth'
require 'thor'
require 'thor/group'
require 'twitter'

class Tomodachi::Auth < Thor::Group
  include Thor::Actions

  CONFIG_PATH = File.expand_path('~/.tomodachi/config.yml')

  def create
    load_access_token(access_token)

    if accounts.find { |account| account[:id] == user[:id] }
      puts "#{user[:screen_name]} is already added."
    else
      accounts += [
        id: user[:id],
        screen_name: user[:screen_name],
        access_token: access_token.token,
        access_token_secret: access_token.secret,
      ]
      save_config(accounts)
      puts "Added configuration for #{user[:screen_name]}"
    end
  end

  def list
    current_conf = accounts
    puts "Available accounts:"
    if current_conf
      current_conf.each do |conf|
        puts "  #{conf[:screen_name]}"
      end
    else
      puts "There is no authenticated account."
    end
  end

  private

  def access_token
    return @access_token if @access_token

    request_token = consumer.get_request_token
    system('open', request_token.authorize_url)
    @access_token = request_token.get_access_token(oauth_verifier: ask('PIN:'))
  end

  def load_access_token(access_token)
    Twitter.configure do |config|
      config.consumer_key = Tomodachi::CONSUMER_KEY
      config.consumer_secret = Tomodachi::CONSUMER_SECRET
      config.oauth_token = access_token.token
      config.oauth_token_secret = access_token.secret
    end
  end

  def user
    @user ||= Twitter.user
  end

  def consumer
    @consumer ||= OAuth::Consumer.new(
      Tomodachi::CONSUMER_KEY,
      Tomodachi::CONSUMER_SECRET,
      site: 'https://api.twitter.com',
    )
  end

  def exist?(screen_name)
    if confs = accounts
      confs.each do |conf|
        if conf[:screen_name] == screen_name
          return true
        end
      end
    end
    false
  end

  def exist_by_id?(id)
    if confs = accounts
      confs.each do |conf|
        if conf[:id] == id
          return true
        end
      end
    end
    false
  end

  def accounts
    @accounts =
      if File.exists?(CONFIG_PATH)
        yaml = File.read(CONFIG_PATH)
        YAML.load(yaml) || []
      else
        []
      end
  end

  def load_token(screen_name)
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

  def save_config(conf)
    File.open(CONFIG_PATH, 'w') do |f|
      f << conf.to_yaml
    end
  end
end
