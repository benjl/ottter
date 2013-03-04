class RenameStreeToStreets < ActiveRecord::Migration
  def up
  	remove_column :users,:stree_origin
  	add_column :users,:street_dest,:string
  	add_column :users,:street_orig,:string
  end

  def down
  end
end
