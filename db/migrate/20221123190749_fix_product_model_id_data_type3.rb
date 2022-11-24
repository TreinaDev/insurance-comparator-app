class FixProductModelIdDataType3 < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :product_category_id, :integer
  end
end
