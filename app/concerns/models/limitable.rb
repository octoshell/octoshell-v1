module Models
  module Limitable
    extend ActiveSupport::Concern
    
    included do
      columns.each do |column|
        case column.type
        when :string then
          validates column.name, length: { maximum: column.limit }
        end
      end
    end
  end
end
