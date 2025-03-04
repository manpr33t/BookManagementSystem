class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :account_number
      t.decimal :balance

      t.timestamps
    end
  end
end
