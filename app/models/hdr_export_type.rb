class HdrExportType < ActiveRecord::Base
  has_many :hdr_query_objects_export_types, dependent: :destroy
  has_many :hdr_query_objects, through: :hdr_query_objects_export_types
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  before_validation :add_name_to_render_types
  default_scope { order("name") }

  def add_name_to_render_types
    if self.render_types && !self.render_types.include?(name)
      self.render_types << name
    elsif !self.render_types
      self.render_types = [name]
    end
  end

  class Entity < Grape::Entity
    expose :name, :id, :render_types
  end
end
