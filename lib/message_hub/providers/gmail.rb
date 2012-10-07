module MessageHub
  module Providers
    class Gmail < MessageHub::Provider
      def login(credentials = {})
        @client = ::Gmail.new(credentials[:username], credentials[:password])
      end

      def fetch_messages(opts = {}, &block)
        check_client_config

        mailbox = @client.label("[Gmail]/All Mail")
        mailbox.emails(opts).map do |email|
          from = email.from[0]

          message_data = {
            :id => email.message_id,
            :source => 'email',
            :title => email.subject,
            :body => extract_body(body),
            :sender_name => "#{from.name || from.mailbox}",
            :sender => "#{from.mailbox}@#{from.host}"
          }

          block.call Message.build(message_data)
        end
      end

      def send_message(opts = {})
        check_client_config
        
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
