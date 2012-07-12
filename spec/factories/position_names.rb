FactoryGirl.define do
  factory :position_name do
    sequence(:name) { |n| "Position Name #{n}" }
  end
end
