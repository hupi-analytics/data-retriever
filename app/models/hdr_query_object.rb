require_relative "hdr_query_engine"
require_relative "hdr_export_type"
require_relative "hdr_filter"
class HdrQueryObject < ActiveRecord::Base
  belongs_to :hdr_query_engine
  belongs_to :hdr_endpoint
  has_many :hdr_query_objects_export_types, dependent: :destroy
  has_many :hdr_export_types, through: :hdr_query_objects_export_types
  has_many :hdr_filters, dependent: :destroy

  validates :query, presence: true

  accepts_nested_attributes_for :hdr_filters, allow_destroy: true

  def render_types
    hdr_export_types.inject([]) do |memo, et|
      memo + et.render_types
    end
  end

  def get_filters(query_filters)
    query_filters ||= {}
    pattern_filter = {}
    hdr_filters.where(name: query_filters.keys).each do |f|
      pattern_filter[f.pattern] ||= []
      tmp = {}
      if query_filters[f.name.to_sym].is_a? Hash
        tmp[:operator] = query_filters[f.name.to_sym][:operator]
        tmp[:value] = query_filters[f.name.to_sym][:value]
      else
        tmp[:operator] = f.default_operator
        tmp[:value] = query_filters[f.name.to_sym]
      end
      tmp[:field] = f.field
      tmp[:value_type] = f.value_type
      pattern_filter[f.pattern] << tmp if tmp[:value] && !tmp[:value].empty?
    end
    pattern_filter
  end

  class Entity < Grape::Entity
    expose :id, :query
    expose :name, safe: true
    expose :hdr_query_engine, using: HdrQueryEngine::Entity, unless: { type: :preview }
    expose :hdr_export_types, using: HdrExportType::Entity, unless: { type: :preview }
    expose :hdr_filters, using: HdrFilter::Entity, unless: { type: :preview }
  end
end
