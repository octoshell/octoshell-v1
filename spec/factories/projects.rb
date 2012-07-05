FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    user
    factory :model, class: 'Project' do
    end
  end
end
