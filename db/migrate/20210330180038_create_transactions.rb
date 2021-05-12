class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.integer :amount
      t.references :content, null: false, foreign_key: true
      t.integer :seller_id, null: false
      t.integer :buyer_id, null: false

      t.timestamps
    end
    add_index :transactions, [:seller_id, :created_at]
    add_index :transactions, [:buyer_id, :created_at]
  end
end
