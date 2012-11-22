class ProjectJoiner
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :user_id, Integer
  attribute :code, String


  def user
    @user ||= User.find(user_id)
  end

  def join
    account_code = AccountUser.find_by_code(code)
    if account_code
      if account_code.use(user)
        account_code.project.user.track! :use_account_code, account_code, current_user
      else
        errors.add :base, account_code.errors
        render :join
      end
    else
      errors.add :code, :not_found
      false
    end
  end

  def persisted?
    false
  end
end
