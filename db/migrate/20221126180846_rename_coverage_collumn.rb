class RenameCoverageCollumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders, :coverage, :insurance_description
  end
end
