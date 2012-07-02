FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    factory :model, class: 'Project' do
    end
  end
end
