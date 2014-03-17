class ClearEmptyUserNotices < ActiveRecord::Migration
  # Чистка таблицы-связки для удалённых notices
  def change
    User::Notice.includes(:notice).find_each do |user_notice|
      user_notice.destroy if user_notice.notice.nil?
    end
  end
end
