# Добавлятор пользователь в проект через секретный код
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
    account_code = AccountCode.find_by_code(code)
    if account_code
      if account_code.use(user)
        account_code.project.user.track! :use_account_code, account_code, user
      else
        errors.add :base, account_code.errors.to_sentence
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
