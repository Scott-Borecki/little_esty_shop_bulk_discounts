class ChangeZipToBeStringInCustomers < ActiveRecord::Migration[5.2]
  def change
    change_column :customers, :zip, :string
  end
end
