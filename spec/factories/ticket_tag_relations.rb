FactoryGirl.define do
  factory :ticket_tag_relation do
    ticket
    ticket_tag
    active false
  end
end
