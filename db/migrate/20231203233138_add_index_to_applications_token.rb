class AddIndexToApplicationsToken < ActiveRecord::Migration[7.1]
  def change
    add_index :applications, :token
  end
end
