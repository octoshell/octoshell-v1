# coding: utf-8
FactoryGirl.define do
  factory :organization do
    sequence(:name) { |n| "Organization #{n}" }
    kind "ВУС"
  end
end
