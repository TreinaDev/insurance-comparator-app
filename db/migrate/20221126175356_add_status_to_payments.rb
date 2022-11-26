class AddStatusToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :status, :integer, default: 0
  end
end
