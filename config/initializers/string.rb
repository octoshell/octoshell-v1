class String
  def supernormalize
    mb_chars.strip.normalize.to_s
  end
end

class NilClass
  def supernormalize
    to_s.supernormalize
  end
end
