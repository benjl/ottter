class AddSmsDoneToAccidents < ActiveRecord::Migration
  def change
  	add_column :accidents, :sms_sent, :boolean, :default => false
  end
end
