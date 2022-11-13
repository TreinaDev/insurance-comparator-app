class RemoveProductFromOrder < ActiveRecord::Migration[7.0]
  def change
    remove_reference :orders, :product, null: false, foreign_key: false
  end
end
