FactoryGirl.define do
  factory :hdr_query_engine do
    sequence(:name) { |n| "qe_#{n}" }

    trait :impala do
      engine "impala"
      settings { { host: "127.0.0.1", port: 21_000 } }
    end

    trait :postgres do
      engine "postgresql"
      settings { { host: "127.0.0.1", dbname: "hdr_test_data", user: "test" } }
    end
  end
end
