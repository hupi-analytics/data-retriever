class HdrFilter < ActiveRecord::Base
  belongs_to :hdr_query_object
  validates :name, presence: true
  validates :pattern, presence: true
  validates :default_operator, presence: true
  validates :field, presence: true

  class Entity < Grape::Entity
    expose :id, if: { type: :full }
    expose :name, :render_types
    expose :pattern, :render_types, unless: { type: :preview }
    expose :default_operator, :render_types, unless: { type: :preview }
    expose :field, :render_types, unless: { type: :preview }
  end
end
