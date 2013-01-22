# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report_comment, :class => 'Report::Comment' do
    message "MyText"
    user_id 1
    report_id 1
  end
end
