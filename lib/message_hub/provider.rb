module MessageHub
  class Provider
    def login(credentials = {})
      raise NotImplementedError
    end

    def fetch_messages(opts = {}, &block)
      raise NotImplementedError
    end

    def send_message(opts = {})
      raise NotImplementedError
    end
  end
end

