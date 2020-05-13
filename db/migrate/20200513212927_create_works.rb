class CreateWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :works do |t|
      t.string :title
      t.string :category
      t.string :creator
      t.string :description
      t.integer :publication_year
      
      t.timestamps
    end
  end
end
