require 'yaml'
require 'oauth'
require 'thor'
require 'thor/group'
require 'twitter'
require 'pry'

class Tomodachi::Auth < Thor::Group
  include Thor::Actions

  CONFIG_PATH = File.expand_path('~/.tomodachi')

  def create
    load_access_token(access_token)

    accounts = load_config || []
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
    accounts = load_config
    if accounts
      puts "Available accounts:"
      accounts.each do |conf|
        puts "  #{conf[:screen_name]}"
      end
    else
      puts 'There is no authenticated account.'
    end
  end

  def load_config
    if File.exists?(CONFIG_PATH)
      yaml = File.read(CONFIG_PATH)
      YAML.load(yaml)
    else
      nil
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

  def save_config(conf)
    File.open(CONFIG_PATH, 'w') do |f|
      f << conf.to_yaml
    end
  end
end
