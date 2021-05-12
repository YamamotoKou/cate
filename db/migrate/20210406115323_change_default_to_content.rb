class ChangeDefaultToContent < ActiveRecord::Migration[6.1]
  def change
    change_column :contents, :status, :integer, default: 0
  end
end
