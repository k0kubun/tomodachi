require 'yaml'
require 'oauth'
require 'thor'
require 'thor/group'
require 'twitter'

module Tomodachi
  class Auth < Thor::Group
    include Thor::Actions
    
    CONFIG_PATH = File.expand_path('~/.tomodachi/config.yml')

    # Twitter for iPhone consumer
    CONSUMER_KEY = 'IQKbtAYlXLripLGPWd0HUA'
    CONSUMER_SECRET = 'GgDYlkSvaPxGxC4X8liwpUoqKwwr3lCADbz8A7ADU'
    
    def create
      consumer = OAuth::Consumer.new(
        CONSUMER_KEY,
        CONSUMER_SECRET,
        :site => 'https://api.twitter.com'
      )
      request_token = consumer.get_request_token

      say request_token.authorize_url
      system 'open', request_token.authorize_url

      pin = ask 'PIN:'

      access_token = request_token.get_access_token(
        :oauth_verifier => pin
      )

      Twitter.configure do |config|
        config.consumer_key = CONSUMER_KEY
        config.consumer_secret = CONSUMER_SECRET
        config.oauth_token = access_token.token
        config.oauth_token_secret = access_token.secret
      end
      user = Twitter.user

      authenticated = false
      current_conf = Auth.load_config
      if current_conf
        current_conf.each do |conf|
          if conf[:id] == user[:id]
            authenticated = true
            break
          end
        end
      else
        current_conf = Array.new
      end

      if authenticated == true
        puts user[:screen_name] + ' is already added.'
      else
        conf = current_conf        
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

    def self.load_config
      path = File.expand_path('~/.tomodachi/')
      if FileTest.exist?(path) == false
        FileUtils.mkdir_p(path)
        return nil
      end
      
      str = nil
      if FileTest.exist?(CONFIG_PATH)
        File.open(CONFIG_PATH, 'r') do |f|
          str = f.read
        end
        YAML.load(str)
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
end
