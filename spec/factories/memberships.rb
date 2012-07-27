FactoryGirl.define do
  factory :membership do
    user
    organization
    
    factory :generic_membership do
      before(:create) do |membership|
        membership.skip_revalidate_user = true
      end
    end
  end
end
