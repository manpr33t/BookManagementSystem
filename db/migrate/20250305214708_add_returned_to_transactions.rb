class AddReturnedToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :returned, :boolean, default: false
    add_column :transactions, :returned_at, :datetime
  end
end
