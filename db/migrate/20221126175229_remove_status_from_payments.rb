class RemoveStatusFromPayments < ActiveRecord::Migration[7.0]
  def change
    remove_column :payments, :status, :integer
  end
end
