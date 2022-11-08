class AddStateToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :state, :string
  end
end
