class CreateFriendRequests < ActiveRecord::Migration
  def change
    create_table :friend_requests do |t|
      t.integer :requester_id
      t.integer :requested_id

      t.timestamps null: false
    end
    add_index :friend_requests, [:requester_id, :requested_id], unique: true
  end
end