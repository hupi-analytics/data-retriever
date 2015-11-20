FactoryGirl.define do
  factory :hdr_query_object do
    sequence(:name) { |n| "test_query_#{n}" }
    association :hdr_query_engine, factory: [:hdr_query_engine, :csv]
    query <<-QUERY
      {
        "path": "public/test/source/test_file.tsv",
        "headers": true,
        "col_sep":"tab",
        "types": {
          "entity_name": "string",
          "memberof_valid": "bool",
          "memberof_share_quantity": "integer",
          "memberof_name": "string",
          "entity_gender": "string",
          "memberof_memberfromint": "int",
          "entity_createat_int": "int",
          "entity_latitude": "double",
          "entity_longitude": "double",
          "entity_type": "string"
        }
      }
    QUERY
    trait :csv do
      query <<-QUERY
        {
          "path": "public/test/source/test_file.tsv",
          "headers": true,
          "col_sep":"tab",
          "types": {
            "entity_name": "string",
            "memberof_valid": "bool",
            "memberof_share_quantity": "integer",
            "memberof_name": "string",
            "entity_gender": "string",
            "memberof_memberfromint": "int",
            "entity_createat_int": "int",
            "entity_latitude": "double",
            "entity_longitude": "double",
            "entity_type": "string"
          }
        }
      QUERY

      after(:create) do |query|
        query.hdr_export_types << create(:hdr_export_type, :csv)
      end
    end

    trait :category_serie_value do
      query <<-QUERY
        {
          "path": "public/test/source/test_file.tsv",
          "headers": true,
          "col_sep": "tab",
          "types": {
            "entity_name": "string",
            "memberof_valid": "bool",
            "memberof_share_quantity": "integer",
            "memberof_name": "string",
            "entity_gender": "string",
            "memberof_memberfromint": "int",
            "entity_createat_int": "int",
            "entity_latitude": "double",
            "entity_longitude": "double",
            "entity_type": "string"
          },
          "rename": [
            { "memberof_name": "category" },
            { "entity_gender": "serie" },
            { "memberof_share_quantity": "value" }
          ]
        }
      QUERY

      after(:create) do |query|
        query.hdr_export_types << create(:hdr_export_type, :category_serie_value)
      end
    end

    trait :two_export_type do
      query <<-QUERY
        {
          "path": "public/test/source/test_file.tsv",
          "headers": true,
          "col_sep": "tab",
          "types": {
            "entity_name": "string",
            "memberof_valid": "bool",
            "memberof_share_quantity": "integer",
            "memberof_name": "string",
            "entity_gender": "string",
            "memberof_memberfromint": "int",
            "entity_createat_int": "int",
            "entity_latitude": "double",
            "entity_longitude": "double",
            "entity_type": "string"
          },
          "rename": [
            { "memberof_name": "category" },
            { "entity_gender": "serie" },
            { "memberof_share_quantity": "value" }
          ]
        }
      QUERY

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
