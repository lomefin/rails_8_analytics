class CreateMetrics < ActiveRecord::Migration[8.0]

  def change
    create_table :metrics do |t|
      t.string :source, index: true
      t.string :name
      t.decimal :value

      t.timestamps
    end
  end

end
