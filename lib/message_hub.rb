$:.unshift File.expand_path("..", __FILE__)

require 'bundler/setup'

Bundler.require(:default)

require 'message_hub/provider'
require 'message_hub/message'
require 'message_hub/providers/gmail'
require 'message_hub/providers/twitter'
require 'message_hub/providers/facebook'

module MessageHub
end

