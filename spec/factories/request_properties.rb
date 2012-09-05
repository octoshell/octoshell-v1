FactoryGirl.define do
  factory :request_property do
    request { Fixture.request }
    sequence(:name) { |n| "Request Property #{n}" }
    value "value"
  end
end
