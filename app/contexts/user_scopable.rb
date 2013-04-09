module UserScopable
  def use_scope(scope)
    users = scoped
    case scope.to_s.to_sym
    when :sured then
      users = users.sured
    end
    users
  end
end
