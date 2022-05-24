class ChangeRelationshipIdType < ActiveRecord::Migration[7.0]
  def change
    change_column :relationships, :follower_id, :bigint
    change_column_null :relationships, :follower_id, false

    change_column :relationships, :followed_id, :bigint
    change_column_null :relationships, :followed_id, false
  end
end
