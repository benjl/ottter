class AddPasswordToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :encrypted_password, :string
  	add_column :users, :salt, :string
  	remove_column :users, :name
  	remove_column :users, :email
  end

  def down
  	remove_column :users, :encrypted_password
  	remove_column :users, :salt
  	add_column :users, :name, :string
  	add_column :users, :email, :string
  end
end
