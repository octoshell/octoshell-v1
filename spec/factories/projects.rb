FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    user
    description 'Description'
    factory :model, class: 'Project' do
    end
  end
end
