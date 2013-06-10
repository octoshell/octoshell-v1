class SessionDataSender < Struct.new(:id, :email)
  def perform
    @session = Session.find(id)
    path = create_archive!
    Mailer.session_archive_is_ready(email, path).deliver!
  end
  
  private
  def create_archive!
    path = "#{Rails.root}/public/archive-#{SecureRandom.hex(8)}.zip"
    
    Zip::ZipFile.open(path, Zip::ZipFile::CREATE) do |z|
      @session.users.each do |user|
        dir = "#{I18n.transliterate(user.full_name)} (##{user.id})"
        if report = user.reports.where(session_id: id).first
          if report.materials.path
            z.add "#{dir}/report.zip", report.materials.path
          end
        end
        user.user_surveys.where(survey_id: @session.survey_ids).each do |us|
          z.add "#{dir}/survey_#{us.id}.zip", us.save_as_html
        end
      end
    end
    File.chmod 0655, path
    path
  end
end
