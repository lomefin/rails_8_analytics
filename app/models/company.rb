class Company < ApplicationRecord

  has_many :users
  has_many :sensors
  has_many :metrics, through: :sensors

end
