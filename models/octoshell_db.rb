# encoding: utf-8

##
# Backup Generated: octoshell_db
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t octoshell_db [-c <path_to_configuration_file>]
#
Backup::Model.new(:octoshell_db, 'Octoshell:PostgreSQL') do
  split_into_chunks_of 250

  store_with S3 do |s3|
    s3.access_key_id     = "KEY_ID"
    s3.secret_access_key = "SECRET_KEY"
    s3.region            = "REGION"
    s3.bucket            = "BUCKET"
    s3.path              = "backups/octoshell/db"
    s3.keep              = 40
  end

  compress_with Gzip
  
  database PostgreSQL do |db|
    db.name               = "octoshell"
    db.username           = "evrone"
  end

  notify_by Mail do |mail|
    mail.on_success           = false
    mail.on_warning           = true
    mail.on_failure           = true
  
    mail.from                 = "backups-notifier@users.parallel.ru"
    mail.to                   = "EMAIL_TO"
  end
end
