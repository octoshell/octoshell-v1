FactoryGirl.define do
  factory :access do
    project
    credential
    cluster
    
    factory :pending_access do
      state 'pending'
    end
    factory :activing_access do
      state 'activing'
    end
    factory :active_access do
      state 'active'
    end
    factory :closing_access do
      state 'closing'
    end
    factory :closed_access do
      state 'closed'
    end
  end
end
