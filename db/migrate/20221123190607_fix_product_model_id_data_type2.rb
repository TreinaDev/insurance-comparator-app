class FixProductModelIdDataType2 < ActiveRecord::Migration[7.0]
  def change
    change_table :orders do |t| 
      change_column :orders, :product_category_id, :integer
    end
  end
end
