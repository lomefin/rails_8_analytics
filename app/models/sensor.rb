# Sensor model representing physical monitoring devices
#
# Sensors are company-scoped devices that generate metrics data.
# Each sensor has a unique code that serves as the primary identifier
# for associating metrics data. The code is globally unique across
# all companies to prevent data conflicts.
#
# @example Creating a sensor and accessing its metrics
#   company = Company.find(1)
#   sensor = company.sensors.create!(
#     name: 'Boiler Pressure Monitor',
#     code: 'BPM001'
#   )
#   latest_readings = sensor.metrics.recently_created
#
# @version 1.0
class Sensor < ApplicationRecord

  belongs_to :company
  has_many :metrics, foreign_key: 'source', primary_key: 'code'

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

end
