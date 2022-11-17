class AddCollumnToEquipment < ActiveRecord::Migration[7.0]
  def change
    add_column :equipment, :equipment_price, :integer
  end
end
