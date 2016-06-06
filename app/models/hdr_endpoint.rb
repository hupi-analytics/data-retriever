require_relative "hdr_query_object"
class HdrEndpoint < ActiveRecord::Base
  has_many :hdr_query_objects, dependent: :destroy
  has_many :hdr_query_objects_export_types, through: :hdr_query_objects
  has_many :hdr_export_types, through: :hdr_query_objects_export_types
  belongs_to :hdr_account
  validates :module_name, :method_name, presence: true
  validates_format_of :module_name, with: /\A[\w-]+\Z/
  validates_format_of :method_name, with: /\A[\w-]+\Z/
  validates_uniqueness_of :method_name, scope: [:module_name]

  accepts_nested_attributes_for :hdr_query_objects, allow_destroy: true

  before_validation :set_module_name_to_account

  default_scope { order(created_at: :desc) }
  def render_types
    hdr_query_objects.inject([]) do |memo, qo|
      memo + qo.render_types
    end.uniq
  end

  def set_module_name_to_account
    if hdr_account
      self.module_name = hdr_account.name
    end
    self
  end

  class Entity < Grape::Entity
    expose :id, :module_name, :method_name, :api, :hdr_account_id
    expose :hdr_query_objects, using: HdrQueryObject::Entity, unless: { type: :preview }
  end
end
