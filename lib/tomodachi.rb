require 'tomodachi/version'
require 'tomodachi/auth'
require 'tomodachi/client'
require 'unindent'

class Tomodachi
  CONSUMER_KEY    = 'IQKbtAYlXLripLGPWd0HUA'
  CONSUMER_SECRET = 'GgDYlkSvaPxGxC4X8liwpUoqKwwr3lCADbz8A7ADU'

  def setup
    case command
    when 'auth'
      auth.create
    when 'list'
      auth.list
    when 'start'
      return print_start_usage if screen_name.nil?

      client = Tomodachi::Client.new(screen_name)
      client.start
    else
      print_usage
    end
  end

  private

  def command
    ARGV[0]
  end

  def screen_name
    ARGV[1]
  end

  def auth
    @auth ||= Tomodachi::Auth.new
  end

  def print_usage
    puts <<-EOS.unindent
      Usage:
        tomodachi auth                # add account
        tomodachi list                # authenticated account list
        tomodachi start [screen_name] # start automatic following back
    EOS
  end

  def print_start_usage
    puts <<-EOS.unindent
      Usage:
        tomodachi start [screen_name]
    EOS
  end
end
