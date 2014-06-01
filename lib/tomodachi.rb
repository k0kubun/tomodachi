require 'tomodachi/version'
require 'tomodachi/auth'
require 'tomodachi/client'
require 'tomodachi/diff'
require 'unindent'

class Tomodachi
  # Twitter for iPhone credentials
  CONSUMER_KEY = 'IQKbtAYlXLripLGPWd0HUA'
  CONSUMER_SECRET = 'GgDYlkSvaPxGxC4X8liwpUoqKwwr3lCADbz8A7ADU'

  def setup
    case ARGV[0]
    when 'auth'
      auth.create
    when 'list'
      auth.list
    when 'start'
      if ARGV[1]
        Tomodachi::Client.start(ARGV[1])
      else
        puts <<-EOS.unindent
          Usage:
            tomodachi start [screen_name]
        EOS
      end
    else
      puts <<-EOS.unindent
        Usage:
          tomodachi auth                # add account
          tomodachi list                # authenticated account list
          tomodachi start [screen_name] # start automatic following back
      EOS
    end
  end

  def auth
    @auth ||= Tomodachi::Auth.new
  end
end
