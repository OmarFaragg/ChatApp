class RemoveSuperfluousIndexes < ActiveRecord::Migration[7.1]
  def change
    remove_index :chats, name: :index_chats_on_application_id
    remove_index :messages, name: :index_messages_on_chat_id
  end
end
