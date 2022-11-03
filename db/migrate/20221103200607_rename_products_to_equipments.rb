class RenameProductsToEquipments < ActiveRecord::Migration[7.0]
  def change
    rename_table :products, :equipments
  end
end
