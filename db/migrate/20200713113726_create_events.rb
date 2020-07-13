class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
      t.text :agenda
      t.text :address
      t.integer :organizer_id

      t.timestamps
    end
  end
end
