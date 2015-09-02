FactoryGirl.define do
  factory :hdr_query_object do
    sequence(:name) { |n| "test_query_#{n}" }
    association :hdr_query_engine, factory: [:hdr_query_engine, :postgres]
    query "select * from #_client_#_entitystatstable"
    trait :csv do
      query "select * from #_client_#_entitystatstable"

      after(:create) do |query|
        query.hdr_export_types << create(:hdr_export_type, :csv)
      end
    end

    trait :category_serie_value do
      query "select memberof_name as category, entity_gender as serie, sum(memberof_share_quantity) as value from #_client_#_entitystatstable #_where_f1_# group by memberof_name, entity_gender"

      after(:create) do |query|
        query.hdr_export_types << create(:hdr_export_type, :category_serie_value)
      end
    end

    trait :two_export_type do
      query "select memberof_name as category, entity_gender as serie, sum(memberof_share_quantity) as value from #_client_#_entitystatstable #_where_f1_# group by memberof_name, entity_gender"

      after(:create) do |query|
        query.hdr_export_types << create(:hdr_export_type, :category_serie_value)
        query.hdr_export_types << create(:hdr_export_type, :csv)
      end
    end

    trait :date_filters do
      after(:create) do |query|
        query.hdr_filters << create(:start_date_filter)
        query.hdr_filters << create(:end_date_filter)
      end
    end
  end
end
