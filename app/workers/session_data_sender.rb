# DJ воркер. Создает и отправляет архив перерегистрации на email
class SessionDataSender < Struct.new(:id, :email)
  def perform
    @session = Session.find(id)
    path = create_archive!
    zip = path[/\/([\-\w]+\.zip)/, 1]
    Mailer.delay.session_archive_is_ready(email, zip)
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
          z.add "#{dir}/survey_#{us.id}.html", us.save_as_file(:html)
          z.add "#{dir}/survey_#{us.id}.json", us.save_as_file(:json)
        end
      end
    end
    File.chmod 0655, path
    path
  end
end
