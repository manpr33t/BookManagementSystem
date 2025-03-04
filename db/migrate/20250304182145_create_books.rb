class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :total_copies
      t.integer :available_copies

      t.timestamps
    end
  end
end
