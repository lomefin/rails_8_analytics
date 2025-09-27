class Sensor < ApplicationRecord

  belongs_to :company
  has_many :metrics, foreign_key: 'source', primary_key: 'code'

end
