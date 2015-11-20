class HdrFilter < ActiveRecord::Base
  belongs_to :hdr_query_object
  validates :name, presence: true
  validates :pattern, presence: true
  validates :default_operator, presence: true
  validates :field, presence: true

  class Entity < Grape::Entity
    expose :id, if: { type: :full }
    expose :name
    expose :pattern, unless: { type: :preview }
    expose :default_operator, unless: { type: :preview }
    expose :field, unless: { type: :preview }
    expose :value_type, unless: { type: :preview }
  end
end
