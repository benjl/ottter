class RemoveStreeOriginFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users,:stree_orig
  end

  def down
  end
end
