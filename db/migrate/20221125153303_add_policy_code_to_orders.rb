class AddPolicyCodeToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :policy_code, :string
  end
end
