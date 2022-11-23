class AddPolicyIdToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :policy_id, :integer
  end
end
