class AddUserForeignKeyToPostComments < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :post_comments, :users, column: :user_id
  end
end
