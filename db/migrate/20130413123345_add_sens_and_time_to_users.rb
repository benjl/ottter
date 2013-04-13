class AddSensAndTimeToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :sens, :boolean
  	add_column :users, :sched, :boolean
  	add_column :users, :sched_mor_start, :time 
  	add_column :users, :sched_mor_end, :time 
  	add_column :users, :sched_eve_start, :time 
  	add_column :users, :sched_eve_end, :time 
  end

  def down
  	remove_column :users, :sens, :boolean
  	remove_column :users, :sched, :boolean
  	remove_column :users, :sched_mor_start, :time 
  	remove_column :users, :sched_mor_end, :time 
  	remove_column :users, :sched_eve_start, :time 
  	remove_column :users, :sched_eve_end, :time 
  end
end
