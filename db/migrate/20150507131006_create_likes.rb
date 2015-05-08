class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :amount
      t.integer :likeable_id
      t.string :likeable_type
      t.timestamps null: false
    end
    add_index :likes, :likeable_id
    add_index :likes, :likeable_type
    add_index :likes, [:user_id, :likeable_id, :likeable_type], unique: true
  end
end
