class AddStatusToAccidents < ActiveRecord::Migration
  def change
    add_column :accidents, :status, :boolean
  end
end
