class Object
  def inherited_by?(klass)
    self.class.inherited_by?(klass)
  end

  def self.inherited_by?(klass)
    ancestors.include?(klass)
  end
end
