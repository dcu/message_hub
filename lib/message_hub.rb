$:.unshift File.expand_path("..", __FILE__)

require 'bundler/setup'

Bundler.require(:default)

require 'message_hub/provider'
require 'message_hub/message'
require 'message_hub/providers/gmail'
require 'message_hub/providers/twitter'
require 'message_hub/providers/facebook'

module MessageHub
  #####
  # Usage:
  #
  #   gmail = MessageHub.provider(:gmail)
  #   gmail.login(:username => "login", :password => "your password")
  #   gmail.fetch_messages(:since => Time.now) do |message|
  #     puts "Received: #{message.inspect}"
  #   end
  #
  def self.provider(name)
    provider_klass = Object.module_eval("MessageHub::Providers::#{name.capitalize}")

    provider_klass.new
  end
end

