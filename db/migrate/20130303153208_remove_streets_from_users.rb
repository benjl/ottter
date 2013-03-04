class RemoveStreetsFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :streets
  end

  def down
  	add_column :users, :streets, :string
  end
end
