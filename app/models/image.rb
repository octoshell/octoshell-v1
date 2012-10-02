class Image
  delegate :images_path, to: :'self.class'
  attr_reader :image, :filename
  
  def initialize(file)
    @filename = file.original_filename
    @image = file.read
  end
  
  def save
    File.open("#{images_path}/#{filename}", "w") do |f|
      f.write image.force_encoding('UTF-8')
    end
    true
  end
  
  class << self
    def all
      Dir.entries(images_path) - ['.', '..', '.gitkeep']
    end
    
    def delete(hash)
      Dir.foreach(images_path) do |f|
        if Digest::SHA1.hexdigest(f) == hash
          File.delete("#{images_path}/#{f}")
          return true
        end
      end
    end
    
    def images_path
      "#{Rails.root}/public/images"
    end
  end
end