class Subdivision < ActiveRecord::Base
  attr_accessor :merge_id
  belongs_to :organization
  
  validates :name, :organization, presence: true
  validates :name, uniqueness: { with: :organization_id }
  
  attr_accessible :name
  attr_accessible :name, :short, as: :admin
  
  def graph_name
    short? ? short : name
  end
  
  def merge(subdivision)
    transaction do
      subdivision.destroy
      Membership.where(subdivision_id: subdivision.id).each do |m|
        m.subdivision = self
        m.save!
      end
    end
  end
end
