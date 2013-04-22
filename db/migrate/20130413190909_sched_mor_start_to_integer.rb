class SchedMorStartToInteger < ActiveRecord::Migration
  def up
  	remove_column :users, :sched_mor_start, :datetime
  	remove_column :users, :sched_mor_end, :datetime
  	remove_column :users, :sched_eve_start, :datetime
  	remove_column :users, :sched_eve_end, :datetime
    add_column :users, :sched_mor_start, :integer
    add_column :users, :sched_mor_end, :integer
    add_column :users, :sched_eve_start, :integer
    add_column :users, :sched_eve_end, :integer
  end

  def down
    add_column :users, :sched_mor_start, :integer
    add_column :users, :sched_mor_end, :integer
    add_column :users, :sched_eve_start, :integer
    add_column :users, :sched_eve_end, :integer
    remove_column :users, :sched_mor_start, :datetime
    remove_column :users, :sched_mor_end, :datetime
    remove_column :users, :sched_eve_start, :datetime
    remove_column :users, :sched_eve_end, :datetime
  end
end
