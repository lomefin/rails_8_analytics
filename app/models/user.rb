# User model representing system users with authentication and API access
#
# Users belong to companies in a multi-tenant architecture. Each user
# has secure password authentication and an automatically generated API key
# for programmatic access to the system.
#
# @example Creating a new user
#   company = Company.find(1)
#   user = User.create!(
#     email_address: 'john@example.com',
#     password: 'secure_password',
#     company: company
#   )
#
# @version 1.0
class User < ApplicationRecord

  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :company

  validates :email_address, presence: true, uniqueness: true
  validates :api_key, uniqueness: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  before_create :generate_api_key

  # Generates a unique API key for the user
  #
  # This method is automatically called before user creation to ensure
  # every user has a unique API key for system access.
  #
  # @return [String] a UUID-format API key
  # @note This is called automatically via before_create callback
  def generate_api_key
    self.api_key = SecureRandom.uuid
  end

end
