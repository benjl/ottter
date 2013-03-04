class AddStreetsOrigToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :stree_orig, :string
  end
end
