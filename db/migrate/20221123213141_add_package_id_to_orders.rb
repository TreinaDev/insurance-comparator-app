class AddPackageIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :package_id, :integer
  end
end
