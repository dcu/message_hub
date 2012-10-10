module MessageHub
  class Message
    attr_accessor :id
    attr_accessor :thread
    attr_accessor :title
    attr_accessor :body
    attr_accessor :source
    attr_accessor :sender_name
    attr_accessor :sender # 'from:' field


    def self.build(atts = {})
      message = Message.new
      atts.each do |key, value|
        message.send(:"#{key}=", value)
      end

      message
    end
  end
end

