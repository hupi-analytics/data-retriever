FactoryGirl.define do
  factory :hdr_endpoint do
    sequence(:module_name) { |n| "module_#{n}" }
    sequence(:method_name) { |n| "method_#{n}" }
    api true

    trait :api_disable do
      api false
    end

    after(:create) do |endpoint|
      endpoint.hdr_query_objects << FactoryGirl.create(:hdr_query_object, :csv, :date_filters)
      endpoint.hdr_query_objects << FactoryGirl.create(:hdr_query_object, :category_serie_value, :date_filters)
    end
  end
end
