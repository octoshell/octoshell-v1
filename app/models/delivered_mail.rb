class DeliveredMail < ActiveRecord::Base
  def self.create_by_mail!(mail)
    scoped.create! do |dm|
      dm.subject = mail.subject
      dm.body = mail.body.raw_source
    end
  end
end
