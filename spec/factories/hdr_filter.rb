FactoryGirl.define do
  factory :hdr_filter do
    factory :start_date_filter do
      name "start_date"
      pattern "where_f1"
      default_operator ">"
      field "entity_createat_int"
      value_type "int"
    end

    factory :end_date_filter do
      name "end_date"
      pattern "where_f1"
      default_operator "<"
      field "entity_createat_int"
      value_type "int"
    end
  end
end
