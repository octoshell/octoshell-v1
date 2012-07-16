PDFKit.configure do |config|
  config.wkhtmltopdf = '/usr/local/bin/wkhtmltopdf'
  config.root_url = 'http://v1.parallel.ru'
end if Rails.env.production?
