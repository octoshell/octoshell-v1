# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fault_reply, :class => 'Fault::Reply' do
    fault_id 1
    message "MyText"
    user_id 1
  end
end
