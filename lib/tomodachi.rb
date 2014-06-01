require 'tomodachi/version'
require 'tomodachi/auth'
require 'tomodachi/client'
require 'tomodachi/diff'

class Tomodachi
  # Twitter for iPhone consumer
  CONSUMER_KEY = 'IQKbtAYlXLripLGPWd0HUA'
  CONSUMER_SECRET = 'GgDYlkSvaPxGxC4X8liwpUoqKwwr3lCADbz8A7ADU'

  def self.setup
    case ARGV[0]
    when 'auth'
      auth = Tomodachi::Auth.new
      auth.create
    when 'list'
      Tomodachi::Auth.list
    when 'start'
      if ARGV[1]
        Tomodachi::Client.start(ARGV[1])
      else
        puts 'Usage: tomodachi start [screen_name]'
      end
    else
      puts <<-EOS
tomodachi auth  # add account
tomodachi list  # authenticated account list
tomodachi start # start automatic following back
      EOS
    end
  end
end
