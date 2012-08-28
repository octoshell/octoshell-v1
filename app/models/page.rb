class Page < ActiveRecord::Base
  FORMAT = :markdown
  WIKI   = Rails.root.join("db", "wiki.git")
  COMMIT = { message: 'commit', name: 'Admin' }
  
  attr_accessor :body
  
  before_create  :create_page
  before_update  :update_page
  before_destroy :delete_page 
  
  validates :body, :name, :url, presence: true
  validates :url, uniqueness: true
  
  attr_accessible :name, :body, :url, as: :admin
  
  def to_param
    url
  end
  
  def body
    @body || raw || ''
  end
  
  def content
    page.try :formatted_data
  end
  
  def raw
    page.raw_data.force_encoding('utf-8')
  rescue
  end
  
  def author
    page.version.author.name.gsub(/<>/, '')
  end

  def date
    page.version.authored_date
  end
  
  def preview(data)
    wiki.preview_page('Preview', data, FORMAT).formatted_data
  end
  
private
  
  def wiki
    @@golum ||= Gollum::Wiki.new(WIKI)
  end
  
  def page
    wiki.page(self.name)
  end
  
  def create_page
    wiki.write_page(name, FORMAT, body, COMMIT)
  end
  
  def update_page
    wiki.update_page(page, name, FORMAT, body, COMMIT)
  end
  
  def delete_page
    wiki.delete_page(page, COMMIT)
  end
end