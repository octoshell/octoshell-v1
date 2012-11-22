module ActiveModel
  class Errors
    def to_s
      full_messages.join(', ')
    end
  end
end
