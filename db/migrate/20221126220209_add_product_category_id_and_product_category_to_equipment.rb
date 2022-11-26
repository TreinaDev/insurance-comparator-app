class AddProductCategoryIdAndProductCategoryToEquipment < ActiveRecord::Migration[7.0]
  def change
    add_column :equipment, :product_category_id, :integer
    add_column :equipment, :product_category, :string
  end
end
