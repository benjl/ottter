class RenameStreetsToStreet1 < ActiveRecord::Migration
  def up
  	remove_column :users, :streets
  end

  def down
  	
  end
end
