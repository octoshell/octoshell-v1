FactoryGirl.define do
  factory :session do
    description 'text'
    
    factory :active_session do
      after(:create) do |session|
        session.start!
      end
    end
  end
end
