class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
      t.string  :key
      t.integer :response_id
      t.string  :return_url

      t.timestamps
    end
  end
end
