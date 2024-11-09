class CreateAuthorsAndGenres < ActiveRecord::Migration[7.2]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :genres do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_reference :books, :author, foreign_key: true
    add_reference :books, :genre, foreign_key: true
  end
end
