class RenameProductsToEquipments < ActiveRecord::Migration[7.0]
  def change
    rename_table :products, :equipment
  end
end
