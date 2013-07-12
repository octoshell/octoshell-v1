# Модель расширения функциональности (для octoshell-extend)
class Extend < ActiveRecord::Base
  attr_accessible :script, :url, :header, :footer, :weight, as: :admin
  
  validates :script, :url, presence: true
  
  def div
    if header?
      header
    elsif footer?
      footer
    else
      "extend"
    end
  end
end
