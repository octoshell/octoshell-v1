class SessionDataSender < Struct.new(:id, :email)
  def perform
    session = Session.find(id)
    path = session.create_archive!
    Mailer.session_archive_is_ready(email, path).deliver!
  end
end
