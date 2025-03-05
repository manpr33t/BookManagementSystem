class AddFeeToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :fee, :decimal, default: 0.0
  end
end
