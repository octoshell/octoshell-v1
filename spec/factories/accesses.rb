FactoryGirl.define do
  factory :access do
    cluster_user
    credential
    
    factory :pending_access do
      state 'pending'
      before :create do |access|
        access.skip_activation = true
      end
    end
    factory :activing_access do
    end
    factory :active_access do
      after(:create) do |access|
        access.tasks.last.force_success
        access.reload
      end
    end
    factory :closing_access do
      after(:create) do |access|
        access.tasks.last.force_success
        access.reload
        access.close!
      end
    end
    factory :closed_access do
      after(:create) do |access|
        access.tasks.last.force_success
        access.reload
        access.close!
        access.tasks.last.force_success
        access.reload
      end
    end
  end
end
