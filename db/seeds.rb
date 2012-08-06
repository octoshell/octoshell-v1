# coding: utf-8

MSU::Application.config.action_mailer.delivery_method = :test

ActiveRecord::Base.transaction do
  # users
  
  if Rails.env.development?
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
  
  # User.create! do |user|
  #   user.email                 = 'serg@parallel.ru'
  #   user.password              = 'octoshell'
  #   user.password_confirmation = 'octoshell'
  #   user.first_name            = 'Sergey'
  #   user.last_name             = 'Zhumatiy'
  #   user.admin                 = true
  # end
  # 
  # User.create! do |user|
  #   user.email                 = 'dan@parallel.ru'
  #   user.password              = 'octoshell'
  #   user.password_confirmation = 'octoshell'
  #   user.first_name            = 'Dmitry'
  #   user.last_name             = 'Nikitenko'
  #   user.admin                 = true
  # end
  
  User.create! do |user|
    user.email                 = 'releu@me.com'
    user.password              = 'octoshell'
    user.password_confirmation = 'octoshell'
    user.first_name            = 'Jan'
    user.last_name             = 'Bernacki'
    user.admin                 = true
  end
  
  user = User.create! do |user|
    user.email                 = 'areleu@gmail.com'
    user.password              = 'octoshell'
    user.password_confirmation = 'octoshell'
    user.first_name            = 'John'
    user.last_name             = 'Smith'
  end
  
  vus = OrganizationKind.create! do |organization_kind|
    organization_kind.name = 'ВУЗ'
  end
  
  OrganizationKind.create! do |organization_kind|
    organization_kind.name = 'РАН'
  end
  
  msu = Organization.create! do |organization|
    organization.organization_kind = vus
    organization.name              = 'МГУ'
  end
  
  evrone = Organization.create! do |organization|
    organization.organization_kind = vus
    organization.name              = 'Evrone'
  end
  
  Membership.create! do |membership|
    membership.organization = evrone
    membership.user = user
  end
  
  Surety.create! do |surety|
    surety.user = user
    surety.organization = msu
  end
  
  Cluster.create! do |cluster|
    cluster.name = 'Ломоносов'
    cluster.host = 'lomonosov.parallel.ru'
  end
  
  Cluster.create! do |cluster|
    cluster.name = 'Чебышёв'
    cluster.host = 'chebyshev.parallel.ru'
  end
  
  Credential.create! do |credential|
    credential.name = 'Macbook'
    credential.public_key = '=== public key'
    credential.user = user
  end
  
  Ticket.create! do |ticket|
    ticket.subject = 'Не могу зайти на кластер'
    ticket.message = 'пишет Permission denied'
    ticket.user = user
  end
  
  PositionName.create! do |name|
    name.name = 'Должность'
  end
  
  PositionName.create! do |name|
    name.name = 'Кафедра'
  end
end
