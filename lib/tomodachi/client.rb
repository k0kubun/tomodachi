require 'user_stream'

class Tomodachi::Client
  def initialize(screen_name)
    @screen_name = screen_name
  end

  def start
    unless account
      puts "#{screen_name} is not authenticated."
      return
    end

    configure(account)
    client.user do |status|
      if status['event'] == 'follow' && status['source']['screen_name'] != @screen_name
        puts "followed #{status['source']['screen_name']}"
        Twitter.follow(status['source']['id'])
      end
    end
  end

  private

  def client
    @client ||= UserStream.client
  end

  def configure(account)
    UserStream.configure do |config|
      config.consumer_key = Tomodachi::CONSUMER_KEY
      config.consumer_secret = Tomodachi::CONSUMER_SECRET
      config.oauth_token = account[:access_token]
      config.oauth_token_secret = account[:access_token_secret]
    end

    Twitter.configure do |config|
      config.consumer_key = Tomodachi::CONSUMER_KEY
      config.consumer_secret = Tomodachi::CONSUMER_SECRET
      config.oauth_token = account[:access_token]
      config.oauth_token_secret = account[:access_token_secret]
    end
  end

  def account
    return @account if @account

    accounts = auth.load_config
    @account = accounts.find { |account| account[:screen_name] == @screen_name }
  end

  def account_exists?(screen_name)
    accounts = auth.load_config
    accounts.find { |account| account[:screen_name] == screen_name }
  end

  def auth
    @auth ||= Tomodachi::Auth.new
  end
end
