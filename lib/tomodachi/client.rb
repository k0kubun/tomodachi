class Tomodachi::Client
  def start(screen_name)
    if Auth.exist?(screen_name)
      conf = Auth.load_token(screen_name)
      UserStream.configure do |config|
        config.consumer_key = Tomodachi::CONSUMER_KEY
        config.consumer_secret = Tomodachi::CONSUMER_SECRET
        config.oauth_token = conf[:access_token]
        config.oauth_token_secret = conf[:access_token_secret]
      end

      Twitter.configure do |config|
        config.consumer_key = Tomodachi::CONSUMER_KEY
        config.consumer_secret = Tomodachi::CONSUMER_SECRET
        config.oauth_token = conf[:access_token]
        config.oauth_token_secret = conf[:access_token_secret]
      end

      client = UserStream.client
      client.user do |status|
        if status['event'] == 'follow' && status['source']['screen_name'] != screen_name
          puts 'followed ' + status['source']['screen_name']
          Twitter.follow(status['source']['id'])
        end
      end

    else
      puts "#{screen_name} is not authenticated."
    end
  end
end
