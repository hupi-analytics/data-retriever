FactoryGirl.define do
  factory :hdr_account do
    sequence(:name) { |n| "account_#{n}" }

    trait :superadmin do
      role "superadmin"
    end
  end
end
