class ChangePriceDataTypeToDecimal < ActiveRecord::Migration[7.0]
  def change
    change_column :equipment, :equipment_price, :decimal
  end
end
