class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    #use add_index to add an index on email column of users table
    #force it to be unique
    add_index :users, :email, unique: true
  end
end
