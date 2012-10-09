module MessageHub
  module Providers
    class Twitter < MessageHub::Provider
      #####
      # Login to gmail
      # options are:
      #   :consumer_key
      #   :consumer_secret
      #   :oauth_token
      #   :oauth_token_secret
      #
      def login(credentials = {})
        @client = Twitter::Client.new(
          :consumer_key => credentials[:consumer_key],
          :consumer_secret => credentials[:consumer_secret],
          :oauth_token => credentials[:oauth_token],
          :oauth_token_secret => credentials[:oauth_token_secret]
        )
      end

      #####
      # Fetch messages from gmail
      # options are:
      #   :since (Time)
      #   :from
      #   :search
      #
      def fetch_messages(opts = {}, &block)
        tweets = if opts[:search]
          @client.search("#{opts[:search]} -rt")
        else
          @client.mentions_timeline
        end

        tweets.each do |tweet|
          message_data = {
            :id => tweet[:id],
            :source => 'twitter',
            :title => tweet[:text],
            :body => tweet[:text],
            :sender_name => tweet[:user][:name],
            :sender => tweet[:user][:screen_name]
          }

          block.call Message.build(message_data)
        end
      end

      #####
      # Send message via gmail
      # options are:
      #   :message
      #
      def send_message(opts = {})
        @client.update(opts[:message])
      end
    end
  end
end

