FactoryGirl.define do
  factory :membership do
    user
    organization
    
    factory :generic_membership do
      before(:after) do |membership|
        membership.skip_revalidate_user = true
      end
    end
  end
end
