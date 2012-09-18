namespace :import do
  task users: :environment do
    file = File.read(ENV['IMPORT_FILE'])
    Importer.import(file)
  end
end
