class HistoryItem < ActiveRecord::Base
  serialize :data
  
  def title
    I18n.t("history_item.#{kind}", id: record_id)
  end
  
  def author
    person = 
      if user_id == author_id
        :self
      elsif author_id?
        :admin
      else
        :system
      end
    I18n.t("history_item.author.#{person}")
  end
  
  def record_id
    data['id']
  end
end
