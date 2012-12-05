class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.string :status
      t.timestamp :published_at
      t.string :category

      t.timestamps
    end
    add_index :posts, :slug
  end
end
