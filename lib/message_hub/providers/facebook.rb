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
      #   :page_id
      #   :since
      #   :search
      #
      #
      def fetch_messages(opts = {}, &block)
        opts[:since] = opts[:since].to_i if opts[:since].kind_of?(Time)
        filter = opts.delete(:search)
        if filter
          filter = Regexp.new(filter.split(/\s+/).join("|"), Regexp::IGNORECASE)
        end

        feed = @client.get_connections(opts.delete(:page_id), "feed", opts)
        loop do
          feed.each do |item|
            if !item['message']
              next
            end

            message_data = {
              :id => item['id'],
              :source => 'facebook',
              :thread => item['id'],
              :body => item['message'],
              :sender_name => item['from']['name'],
              :sender => item['from']['id']
            }

            if !filter
              block.call Message.build(message_data)
            elsif message_data[:body] =~ filter
              block.call Message.build(message_data)
            end

          end
          feed = feed.next_page

          break if feed.nil?
        end
      end

      #####
      # Send message via gmail
      # options are:
      #   :page_id
      #   :message
      #
      def send_message(opts = {})
        @client.put_connections(params[:page_id], "feed", :message => opts[:message])
      end
    end
  end
end
