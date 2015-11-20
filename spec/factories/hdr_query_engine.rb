FactoryGirl.define do
  factory :hdr_query_engine do
    sequence(:name) { |n| "qe_#{n}" }

    trait :csv do
      engine "csv"
      settings { Hash.new }
    end
  end
end
