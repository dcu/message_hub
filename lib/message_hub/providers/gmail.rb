module MessageHub
  module Providers
    class Gmail < MessageHub::Provider
      #####
      # Login to gmail
      # options are:
      #   :username
      #   :password
      #
      def login(credentials = {})
        @client = ::Gmail.new(credentials[:username], credentials[:password])
      end

      #####
      # Fetch messages from gmail
      # options are:
      #   :since (Time)
      #   :from
      #   :search
      #
      def fetch_messages(opts = {}, &block)
        check_client_config

        opts[:after] = opts.delete(:since) if opts.include?(:since)

        mailbox = @client.label("INBOX")
        mailbox.emails(:all, opts).map do |email|
          from = email.from[0]

          message_data = {
            :id => email.message_id,
            :source => 'email',
            :thread => email.thread_id,
            :title => email.subject,
            :body => extract_body(email),
            :sender_name => "#{from.name || from.mailbox}",
            :sender => "#{from.mailbox}@#{from.host}"
          }

          block.call Message.build(message_data)
        end
      end

      #####
      # Send message via gmail
      # options are:
      #   :to
      #   :title (optional)
      #   :message
      #
      def send_message(opts = {})
        check_client_config

        # build the email
        mail = @client.compose
        mail.to opts[:to]
        mail.subject opts[:title]
        mail.html_part do
          content_type 'text/html; charset=UTF-8'
          body opts[:message]
        end
        mail.deliver!
      end

      private
      def check_client_config
        if !@client
          raise ArgumentError, "You have to call #{self.class}#login(:username => 'foo', :password => 'pass') first."
        end
      end

      def extract_body(email) 
        if html_part = email.parts.find {|part| part["Content-Type"].to_s =~ /html/ }
          return html_part.body.to_s
        end
        return email.parts.empty? ? email.body.to_s : email.parts[0].body.to_s
      end
    end
  end
end
