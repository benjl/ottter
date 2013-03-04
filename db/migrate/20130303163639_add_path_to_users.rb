class AddPathToUsers < ActiveRecord::Migration
  def change
  	add_column :users,:path,:string
  end
end
