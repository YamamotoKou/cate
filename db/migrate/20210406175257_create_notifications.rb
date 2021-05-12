class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :sender, foreign_key:{ to_table: :users }, null: false
      t.references :recipient, foreign_key:{ to_table: :users }, null: false
      t.references :micropost, foregin_key: true
      t.string :action, default: '', null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
  end
end