class CreateGroupEvents < ActiveRecord::Migration[5.2]
  def change
  	create_table :group_events do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :name
      t.text :description
      t.string :location
      t.datetime :deleted_at
      t.string :status, default: 'draft'
  	  t.timestamps
  	end
  end
end
