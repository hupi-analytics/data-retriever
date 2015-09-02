class HdrQueryEngine < ActiveRecord::Base
  has_many :hdr_query_objects, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :engine, presence: true

  def init
    qe = Object.const_get("#{self.engine.capitalize}QueryEngine").new(self.settings)
    qe.connect
    qe
  end

  class Entity < Grape::Entity
    expose :id, :name
    expose :engine, :desc, :settings, if: { type: :full }
  end
end
