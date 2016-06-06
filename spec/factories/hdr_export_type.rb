FactoryGirl.define do
  sequence(:het_name) { |n| "export_type_#{n}" }

  factory :hdr_export_type do
    name { generate(:het_name) }
    render_types { %w(csv) }

    trait :csv do
      name "csv"
      render_types { %w(csv) }
    end

    trait :category_serie_value do
      name "category_serie_value"
      render_types { %w(category_serie_value column_stacked_normal column_stacked_percent basic_line basic_area stacked_area area_stacked_percent multiple_column windrose spiderweb) }
    end
  end
end
