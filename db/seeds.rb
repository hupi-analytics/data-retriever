require_relative "../config/environment"

HdrExportType.find_or_create_by(name: "boxplot")
HdrExportType.find_or_create_by(name: "category_serie_value")
HdrExportType.find_or_create_by(name: "column")
HdrExportType.find_or_create_by(name: "column_stacked_grouped")
HdrExportType.find_or_create_by(name: "csv")
HdrExportType.find_or_create_by(name: "fixed_placement_column")
HdrExportType.find_or_create_by(name: "small_heatmap")
HdrExportType.find_or_create_by(name: "large_heatmap")
HdrExportType.find_or_create_by(name: "heatmap")
HdrExportType.find_or_create_by(name: "json_array")
HdrExportType.find_or_create_by(name: "json_value")
HdrExportType.find_or_create_by(name: "leaflet")
HdrExportType.find_or_create_by(name: "multiple_csv")
HdrExportType.find_or_create_by(name: "serie_value")
HdrExportType.find_or_create_by(name: "value")
HdrExportType.find_or_create_by(name: "cursor")
HdrExportType.find_or_create_by(name: "bubble")

et = HdrExportType.find_by(name: "category_serie_value")
et.update(render_types:  %w(column_stacked_normal column_stacked_percent basic_line basic_area stacked_area stacked_area_percent multiple_column windrose spiderweb))

et = HdrExportType.find_by(name: "serie_value")
et.update(render_types: %w(column half_donuts pie_chart funnel))

et = HdrExportType.find_by(name: "json_value")
et.update(render_types: %w(treemap2 treemap3))

HdrAccount.find_or_create_by(name: "hupi")
