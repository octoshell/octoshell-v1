# encoding: utf-8

##
# Backup Generated: octoshell_files
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t octoshell_files [-c <path_to_configuration_file>]
#
Backup::Model.new(:octoshell_files, 'Description for octoshell_files') do

  sync_with Cloud::S3 do |s3|
    s3.access_key_id     = "KEY_ID"
    s3.secret_access_key = "SECRET_KEY"
    s3.region            = "REGION"
    s3.bucket            = "BUCKET"
    s3.path              = "backups/octoshell/files"
    s3.mirror            = true
    s3.concurrency_type  = :threads
    s3.concurrency_level = 50

    s3.directories do |directory|
      directory.add "/var/www/octoshell/shared/system"
    end
  end

  compress_with Gzip

  notify_by Mail do |mail|
    mail.on_success           = false
    mail.on_warning           = true
    mail.on_failure           = true
  
    mail.from                 = "backups-notifier@users.parallel.ru"
    mail.to                   = "EMAIL_TO"
  end
end
