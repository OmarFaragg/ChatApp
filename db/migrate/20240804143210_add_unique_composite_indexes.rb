class AddUniqueCompositeIndexes < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :chats, :applications
    remove_foreign_key :messages, :chats

    remove_index :chats, name: :index_chats_on_application_id_and_number
    remove_index :messages, name: :index_messages_on_chat_id_and_number

    add_index :chats, [:application_id, :number], unique: true, name: 'index_chats_on_application_id_and_number'
    add_index :messages, [:chat_id, :number], unique: true, name: 'index_messages_on_chat_id_and_number'

    add_foreign_key :chats, :applications
    add_foreign_key :messages, :chats
  end
end
