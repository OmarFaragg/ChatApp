class AddIndexRemoveColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :applications, :previous_request_timestamp
    add_index :messages, [:chat_id, :number]
  end
end
