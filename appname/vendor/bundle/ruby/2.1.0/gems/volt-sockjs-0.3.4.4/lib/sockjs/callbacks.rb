module SockJS
  module CallbackMixin
    attr_accessor :status

    def callbacks
      @callbacks ||= Hash.new { |hash, key| hash[key] = Array.new }
    end

    def execute_callback(name, *args)
      if self.callbacks.has_key?(name)
        self.callbacks[name].each do |callback|
          callback.call(*args)
        end
      else
        raise ArgumentError.new("There's no callback #{name.inspect}. Available callbacks: #{self.callbacks.keys.inspect}")
      end
    end
  end
end
