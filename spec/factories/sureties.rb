FactoryGirl.define do
  factory :surety do
    boss_full_name 'Boss Name'
    boss_position 'Boss Position'
    project
    factory :active_surety do
      after(:create) do |surety|
        surety.activate!
      end
    end
  end
end
