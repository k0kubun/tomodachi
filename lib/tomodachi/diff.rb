class Tomodachi::Diff
  def self.show(screen_name)
    if Tomodachi::Auth.exist?(screen_name)
      conf = Tomodachi::Auth.load_token(screen_name)
      client = Twitter::REST::Client.new do |config|
        config.consumer_key = Tomodachi::CONSUMER_KEY
        config.consumer_secret = Tomodachi::CONSUMER_SECRET
        config.oauth_token = conf[:access_token]
        config.oauth_token_secret = conf[:access_token_secret]
      end

      follower_ids = client.follower_ids.to_a
      following_ids = client.friend_ids.to_a

      target_ids = follower_ids - following_ids
      puts "Followers you do not follow (#{target_ids.count}):"
      target_ids.each do |id|
        screen_name = client.user(id).screen_name
        puts "  #{screen_name}"
        sleep(0.3)
      end

      target_ids = following_ids - follower_ids
      puts "Followings you are not followed (#{target_ids.count}):"
      target_ids.each do |id|
        screen_name = client.user(id).screen_name
        puts "  #{screen_name}"
        sleep(0.3)
      end
    else
      puts "#{screen_name} is not authenticated."
    end
  end
end
