class AddAttributesToOrder < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :client, null: false, foreign_key: true
    add_column :orders, :status, :integer, default: 0
  end
end
