class SchedMorStartToInteger < ActiveRecord::Migration
  def up
  	change_column :users, :sched_mor_start, :integer
  	change_column :users, :sched_mor_end, :integer
  	change_column :users, :sched_eve_start, :integer
  	change_column :users, :sched_eve_end, :integer
  end

  def down
  	change_column :users, :sched_mor_start, :datetime
  	change_column :users, :sched_mor_end, :datetime
  	change_column :users, :sched_eve_start, :datetime
  	change_column :users, :sched_eve_end, :datetime
  end
end
