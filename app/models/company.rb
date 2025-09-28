# Company model representing multi-tenant organizations
#
# Companies serve as the top-level entity in the multi-tenant architecture.
# Each company has its own users, sensors, and metrics, providing complete
# data isolation between different organizations using the system.
#
# @example Creating a company with sensors
#   company = Company.create!(name: 'Acme Manufacturing')
#   sensor = company.sensors.create!(name: 'Pressure Sensor 1', code: 'PS001')
#
# @version 1.0
class Company < ApplicationRecord

  has_many :users
  has_many :sensors
  has_many :metrics, through: :sensors

  validates :name, presence: true

end
