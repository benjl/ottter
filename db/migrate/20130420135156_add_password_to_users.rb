class AddPasswordToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :encrypted_password, :string
  	add_column :users, :salt, :string
  	remove_column :users, :name, :string
  	remove_column :users, :email, :string
  end

  def down
  	remove_column :users, :encrypted_password, :string
  	remove_column :users, :salt, :string
  	add_column :users, :name, :string
  	add_column :users, :email, :string
  end
end
