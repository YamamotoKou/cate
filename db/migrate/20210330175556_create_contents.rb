class CreateContents < ActiveRecord::Migration[6.1]
  def change
    create_table :contents do |t|
      t.references :micropost, null: false, foreign_key: true
      t.text :sentence
      t.string :title
      t.integer :price
      t.integer :status

      t.timestamps
    end
  end
end
