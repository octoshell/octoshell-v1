module StateMachine
  class InvalidTransition < Error
    def initialize(object, machine, event)
      @machine = machine
      @from_state = machine.states.match!(object)
      @from = machine.read(object, :state)
      @event = machine.events.fetch(event)
      
      if object.errors.any?
        message = object.errors.messages.values.join(', ')
      else
        message = "Cannot transition #{machine.name} via :#{self.event} from #{from_name.inspect}"
      end
      super(object, message)
    end
  end
end
