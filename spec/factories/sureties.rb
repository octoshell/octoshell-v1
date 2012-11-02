FactoryGirl.define do
  factory :surety do
    direction_of_science
    boss_full_name 'Boss Name'
    boss_position 'Boss Position'
    project
    critical_technologies { [create(:critical_technology)] }
    factory :active_surety do
      after(:create) do |surety|
        surety.activate!
      end
    end
  end
end
