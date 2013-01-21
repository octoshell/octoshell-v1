# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report_reply, :class => 'Report::Reply' do
    report_id 1
    message "MyText"
    user_id 1
  end
end
