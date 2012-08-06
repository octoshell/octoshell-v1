class ActiveRecord::Base
  
  def self.define_state_machine_scopes
    state_machine.states.map(&:name).each do |state|
      scope state, where(state: state)
      scope "non_#{state}", where("#{table_name}.state != '#{state}'")
    end
  end
  
  def self.define_defaults_events *events
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
end
