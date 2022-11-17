class AddInsuranceInfoToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :insurance_name, :string
    add_column :orders, :packages, :string
    add_column :orders, :insurance_model, :string
  end
end
