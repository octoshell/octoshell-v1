# coding: utf-8
ActiveRecord::Base.transaction do
  # users
  
  if Rails.env.development?
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
  
  if Rails.env.production?
    User.create! do |user|
      user.email                 = 'serg@parallel.ru'
      user.password              = 'octoshell'
      user.password_confirmation = 'octoshell'
      user.first_name            = 'Sergey'
      user.last_name             = 'Zhumatiy'
      user.admin                 = true
    end
  
    User.create! do |user|
      user.email                 = 'dan@parallel.ru'
      user.password              = 'octoshell'
      user.password_confirmation = 'octoshell'
      user.first_name            = 'Dmitry'
      user.last_name             = 'Nikitenko'
      user.admin                 = true
    end
  end
  
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
  end
  
  Cluster.create! do |cluster|
    cluster.name = 'Чебышёв'
  end
  
  Credential.create! do |credential|
    credential.name = 'Macbook'
    credential.public_key = '=== public key'
    credential.user = user
  end
end
