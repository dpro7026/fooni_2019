class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :location
      t.decimal :member_price
      t.decimal :non_member_price
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
