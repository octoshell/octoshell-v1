# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cluster_log, :class => 'Cluster::Log' do
    cluster_id 1
    message "MyString"
  end
end
