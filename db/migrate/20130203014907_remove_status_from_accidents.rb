class RemoveStatusFromAccidents < ActiveRecord::Migration
  def up
  	remove_column :accidents, :status
  end

  def down
  	add_column :accidents, :status, :boolean
  end
end
