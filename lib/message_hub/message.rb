module MessageHub
  class Message
    attr_accessor :id
    attr_accessor :title
    attr_accessor :body
    attr_accessor :source
    attr_accessor :sender_name
    attr_accessor :sender # 'from:' field
  end
end

