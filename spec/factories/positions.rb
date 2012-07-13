FactoryGirl.define do
  factory :position do
    membership
    sequence(:name) { |n| "Position Name #{n}" }
    value 'Atata'
  end
end
