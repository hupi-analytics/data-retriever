class HdrQueryEngine < ActiveRecord::Base
  # This has to be before has_many to hdr_query_objects, else this will fail,
  # because query_objects will be deleted by then
  before_destroy :check_for_endpoints
  belongs_to :hdr_account
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :engine, presence: true
  default_scope { order("name") }
  has_many :hdr_query_objects, dependent: :destroy

  def init(client)
    qe = Object.const_get("#{self.engine.capitalize}QueryEngine").new(client, self.settings)
    qe.connect()
    qe
  end

  def check_for_endpoints
    raise ActiveRecord::ActiveRecordError.new("Can't delete Query Engine, it has endpoints linked to it")  if self.hdr_query_objects.count > 0
  end

  class Entity < Grape::Entity
    expose :id, :name, :hdr_account_id
    expose :engine, :desc, :settings, if: { type: :full }
  end
end
