class HdrAccount < ActiveRecord::Base
  has_many :hdr_endpoints, dependent: :destroy
  has_many :hdr_query_engines, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  before_create :generate_access_token

  class Entity < Grape::Entity
    expose :id, :name
    expose :access_token, :role, if: { type: :full }
  end

  def generate_access_token
    self.access_token = SecureRandom.hex
  end

  def superadmin?
    role == "superadmin"
  end
end
