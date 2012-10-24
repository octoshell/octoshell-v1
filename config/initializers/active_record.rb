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
          define_safe_state_event_method(event)
          define_state_event_method(event)
        end
      end
      
      def define_safe_state_event_method(event)
        define_method event do
          return false unless send("can__#{event}?")
          send "#{event}!"
        end
      end
      
      def define_state_event_method(event)
        define_method "#{event}!" do
          send "_#{event}!"
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

module Generic
  def to_generic_model
    klass = Class.new(ActiveRecord::Base)
    klass.table_name = table_name
    klass
  end
end

ActiveRecord::Base.extend(Generic)
