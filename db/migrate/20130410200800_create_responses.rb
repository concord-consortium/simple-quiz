class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.text :answer

      t.timestamps
    end
  end
end
