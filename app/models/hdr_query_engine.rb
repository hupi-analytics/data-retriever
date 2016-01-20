class HdrQueryEngine < ActiveRecord::Base
  has_many :hdr_query_objects, dependent: :destroy
  belongs_to :hdr_account
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :engine, presence: true
  default_scope { order("name") }

  def init(client)
    qe = Object.const_get("#{self.engine.capitalize}QueryEngine").new(client, self.settings)
    qe.connect()
    qe
  end

  class Entity < Grape::Entity
    expose :id, :name
    expose :engine, :desc, :settings, :hdr_account_id, if: { type: :full }
  end
end
