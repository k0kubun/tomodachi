require "tomodachi/version"
require "tomodachi/auth"
require "tomodachi/client"
require 'pp'

module Tomodachi
  def self.setup
    case ARGV[0]
    when "auth"
      auth = Tomodachi::Auth.new
      auth.create
    when "list"
    when "init"
    when "start"
    when "load"
      Tomodachi::Auth.load_config
    when "save"
      Tomodachi::Auth.create
    else
      print(<<-"EOS")
      Usage
        tomodachi auth
        tomodachi list
        tomodachi init screen_name
        tomodachi start screen_name
      EOS
    end
  end
end