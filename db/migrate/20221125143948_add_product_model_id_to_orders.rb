class AddProductModelIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :product_model_id, :integer
  end
end
