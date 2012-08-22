module Models
  module Asynch
    extend ActiveSupport::Concern
    
    # вызывет колбеки удачного продолжения процедуры
    def continue!(procedure, task)
      method = "continue_#{procedure}"
      send(method, task) if respond_to?(method)
    end
    
    # вызывет колбеки провального продолжения процедуры
    def stop!(procedure)
      method = "stop_#{procedure}"
      send(method) if respond_to?(method)
    end
  end
end
