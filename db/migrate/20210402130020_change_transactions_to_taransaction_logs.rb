class ChangeTransactionsToTaransactionLogs < ActiveRecord::Migration[6.1]
  def change
    rename_table :transactions, :transaction_logs
  end
end