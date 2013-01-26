class CreateAccidents < ActiveRecord::Migration
  def change
    create_table :accidents do |t|
      t.integer :tid
      t.string :details
      t.string :time

      t.timestamps
    end
  end
end
