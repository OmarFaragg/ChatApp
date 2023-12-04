class UpdateChatsIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :chats, :number
    add_index :chats, [:application_id, :number]
  end
end
