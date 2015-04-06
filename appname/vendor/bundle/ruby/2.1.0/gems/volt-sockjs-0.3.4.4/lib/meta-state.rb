

module MetaState
  class Error < ::StandardError; end
  class WrongStateError < Error; end
  class InvalidStateError < Error; end

  class Machine
    NON_MESSAGES = [:on_exit, :on_enter]

    class << self
      def add_state(state)
        @default_state ||= state
        states
        @states[state] = true
        name = state.name.sub(/.*::/,'').downcase
        state_names
        @state_names[name] = state
        @state_names[name.to_sym] = state
        include state
        @void_state_module = nil
      end

      def state(name, &block)
        mod = Module.new(&block)
        const_set(name, mod)
        add_state(mod)
      end

      def default_state
        @default_state || superclass.default_state
      end

      def void_state_module
        if @void_state_module.nil?
          build_void_state
        end
        @void_state_module
      end

      #Explicitly set the default (i.e. initial state) for an FSM
      #Normally, this defaults to the first state defined, but some folks like
      #to be explicit
      def default_state=(state)
        @default_state = state
      end

      def state_names
        @state_names ||= {}
        if Machine > superclass
          superclass.state_names.merge(@state_names)
        else
          @state_names
        end
      end

      def states
        @states ||= {}
        if Machine > superclass
          superclass.states.merge(@states)
        else
          @states
        end
      end

      def build_void_state
        methods = (self.states.keys.map do |state|
          state.instance_methods
        end.flatten + NON_MESSAGES).uniq

        @void_state_module = Module.new do
          methods.each do |method|
            if NON_MESSAGES.include?(method)
              define_method(method){|*args| }
            else
              define_method(method) do |*args|
                raise WrongStateError, "Message #{method} received in state #{current_state}"
              end
            end
          end
        end

        include @void_state_module
      end
    end

    #Explicitly put an FSM into a particular state.  Simultaneously enters a
    #state of sin.  Use sparingly if at all.
    def state=(state)
      mod = state_module(state)
      assign_state(mod)
    end

    def debug_with(&block)
      @debug_block = block
    end

    attr_reader :current_state
    def initialize
      @debug_block = nil
      assign_state(self.class.default_state)
    end

    protected

    def debug
      return if @debug_block.nil?
      message = yield
      @debug_block[message]
    end

    def assign_state(mod)
      force_extend(self.class.void_state_module)
      force_extend(mod)
      @current_state = mod
    end

    def force_extend(mod)
      mod.instance_methods.each do |method_name|
        define_singleton_method(method_name, mod.instance_method(method_name))
      end
    end

    def state_module(state)
      unless state.is_a? Module
        state = self.class.state_names[state] unless state.is_a? Module
      end
      raise InvalidStateError unless self.class.states[state]
      return state
    end

    def transition_to(state)
      target_state = state_module(state)
      return true if target_state == current_state
      source_state = current_state

      debug{ "Transitioning from #{source_state.inspect} to #{target_state.inspect}" }

      on_exit

      warn "State changed after on_exit method.  Became: #{current_state.inspect}" unless source_state == current_state

      assign_state(target_state)

      on_enter

      warn "State changed after on_enter method.  Became: #{current_state.inspect}" unless target_state == current_state
    end

  end
end
