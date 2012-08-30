FactoryGirl.define do
  factory :task do
    procedure Task::PROCEDURES.first
    association :resource, factory: :cluster_user
        
    factory :failed_task do
      state 'failed'
    end
    
    factory :add_user_task do
      association :resource, factory: :activing_cluster_user
      procedure 'add_user'
    end
    
    factory :del_user_task do
      association :resource, factory: :closing_cluster_user
      procedure 'del_user'
    end
    
    factory :block_user_task do
      association :resource, factory: :pausing_cluster_user
      procedure 'block_user'
    end
    
    factory :unblock_user_task do
      association :resource, factory: :resuming_cluster_user
      procedure 'unblock_user'
    end
    
    factory :add_openkey_task do
      association :resource, factory: :activing_access
      procedure 'add_openkey'
    end
    
    factory :del_openkey_task do
      association :resource, factory: :closing_access
      procedure 'del_openkey'
    end
  end
end
