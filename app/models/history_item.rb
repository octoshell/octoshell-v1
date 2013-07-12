# Запись истории действия пользователя
class HistoryItem < ActiveRecord::Base
  serialize :data
  
  def title
    I18n.t("history_item.#{kind}", id: record_id)
  end
  
  def author
    
    I18n.t("history_item.author.#{author_sym}")
  end
  
  def author_sym
    if author_id?
      user = User.find(author_id)
      user.admin? ? :admin : :self
    else
      :system
    end
  end
  
  def record_id
    data['id']
  end
end
