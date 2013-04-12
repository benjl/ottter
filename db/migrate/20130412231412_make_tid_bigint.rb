class MakeTidBigint < ActiveRecord::Migration
  def up
  	change_column :accidents, :tid, :bigint
  end

  def down
  	change_column :accidents, :tid, :integer
  end
end
