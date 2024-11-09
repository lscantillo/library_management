class RemoveAuthorsandgenre < ActiveRecord::Migration[7.2]
  def change
    remove_column :books, :author, :string
    remove_column :books, :genre, :string
  end
end
