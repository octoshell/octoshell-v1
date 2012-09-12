module ActiveRecord
  class Base
    class << self
      def define_state_machine_scopes
        state_machine.states.map(&:name).each do |state|
          scope state, where(state: state)
          scope "non_#{state}", where("#{table_name}.state != '#{state}'")
        end
      end

      def define_defaults_events *events
        events.each do |event|
          define_method event do
            return false unless send("can__#{event}?")
            send "#{event}!"
          end

          define_method "#{event}!" do
            send "_#{event}!"
          end
        end
      end

      def human_state_names
        Hash[state_machine.states.map do |state|
          [state.human_name, state.name]
        end]
      end

      def state_names
        state_machine.states.map &:name
      end
    end
  end
  
  class RecordInProcess < StandardError
  end
end
