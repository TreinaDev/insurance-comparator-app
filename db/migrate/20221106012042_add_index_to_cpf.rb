class AddIndexToCpf < ActiveRecord::Migration[7.0]
  def change
    add_index :clients, :cpf, unique: true
  end
end
