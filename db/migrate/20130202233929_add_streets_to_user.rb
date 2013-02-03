class AddStreetsToUser < ActiveRecord::Migration
  def change
    add_column :users, :streets, :string
  end
end
