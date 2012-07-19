class ActiveRecord::Base
  
  def self.define_defaults_events *events
    events.each do |event|
      define_method event do
        send "_#{event}"
      end

      define_method "#{event}!" do
        send "_#{event}!"
      end
    end
  end
end
