# coding: utf-8
FactoryGirl.define do
  factory :institute do
    sequence(:name) { |n| "Institute #{n}" }
    kind "ВУС"
  end
end
