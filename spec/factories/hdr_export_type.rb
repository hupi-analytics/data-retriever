FactoryGirl.define do
  factory :hdr_export_type do
    sequence(:name) { |n| "export_type_#{n}" }

    trait :csv do
      render_types { %w(csv) }
    end

    trait :category_serie_value do
      render_types { %w(category_serie_value column_stacked_normal column_stacked_percent basic_line basic_area stacked_area area_stacked_percent multiple_column windrose spiderweb) }
    end
  end
end
