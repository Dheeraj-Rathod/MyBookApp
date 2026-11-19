class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :author
      t.text :description
      t.string :isbn
      t.integer :published_year

      t.timestamps
    end
  end
end
