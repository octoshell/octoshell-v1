class HistoryItem < ActiveRecord::Base
  serialize :data
  
  def title
    I18n.t("history_item.#{kind}", id: record_id)
  end
  
  def author
    person = 
      if author_id?
        user = User.find(author_id)
        user.admin? ? :admin : :self
      else
        :system
      end
    I18n.t("history_item.author.#{person}")
  end
  
  def record_id
    data['id']
  end
end
