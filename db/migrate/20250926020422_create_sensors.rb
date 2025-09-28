class CreateSensors < ActiveRecord::Migration[8.0]

  def change
    create_table :sensors do |t|
      t.string :name
      t.string :code, index: true
      t.string :state, default: 'new'
      t.integer :metrics_count, default: 0, null: false
      t.belongs_to :company, null: false, foreign_key: true

      t.timestamps
    end
  end

end
