class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :token, null: false
      t.string :name, null: false
      t.integer :chats_count
      t.timestamp :previous_request_timestamp

      t.timestamps
    end
  end
end
