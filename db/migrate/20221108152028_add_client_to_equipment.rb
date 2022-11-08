class AddClientToEquipment < ActiveRecord::Migration[7.0]
  def change
    add_reference :equipment, :client, null: false, foreign_key: true
  end
end
