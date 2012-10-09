module MessageHub
  module Providers
    class Facebook < MessageHub::Provider
      #####
      # Login to gmail
      # options are:
      #   :access_token
      def login(credentials = {})
        @client = Koala::Facebook::API.new(credentials[:access_token])
      end

      #####
      # Fetch messages from gmail
      # options are:
      #
      def fetch_messages(opts = {}, &block)
      end

      #####
      # Send message via gmail
      # options are:
      #   :message
      #
      def send_message(opts = {})
        @client.put_connections("me", "feed", :message => opts[:message])
      end
    end
  end
end
