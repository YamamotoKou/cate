class ChangePriceDefaultToContent < ActiveRecord::Migration[6.1]
  def change
    change_column :contents, :price, :integer, default: 0
  end
end
