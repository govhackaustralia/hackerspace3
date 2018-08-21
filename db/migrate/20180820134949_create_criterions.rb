class CreateCriterions < ActiveRecord::Migration[5.2]
  def change
    create_table :criterions do |t|
      t.integer :competition_id
      t.text :description
      t.string :category

      t.timestamps
    end
  end
end
