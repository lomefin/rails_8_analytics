class User < ApplicationRecord

  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :company

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  before_create :generate_api_key

  def generate_api_key
    self.api_key = SecureRandom.uuid
  end

end
