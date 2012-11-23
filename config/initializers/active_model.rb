module ActiveModel
  class Errors
    def to_sentence
      full_messages.to_sentence
    end
  end
end
