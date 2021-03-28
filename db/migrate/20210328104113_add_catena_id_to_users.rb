class AddCatenaIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :catena_id, :string
  end
end
