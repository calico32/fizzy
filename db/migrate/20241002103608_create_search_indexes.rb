class CreateSearchIndexes < ActiveRecord::Migration[8.0]
  def change
    create_virtual_table :bubbles_search_index, "fts5", [ "title" ]
    create_virtual_table :comments_search_index, "fts5", [ "body" ]
  end
end
