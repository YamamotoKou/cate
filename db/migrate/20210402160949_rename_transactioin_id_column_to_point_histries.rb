class RenameTransactioinIdColumnToPointHistries < ActiveRecord::Migration[6.1]
  def change
    rename_column :point_histories, :transaction_id, :transaction_log_id
  end
end