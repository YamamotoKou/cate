class RenameContentColumnToMicropots < ActiveRecord::Migration[6.1]
  def change
    rename_column :microposts, :content, :text
  end
end
