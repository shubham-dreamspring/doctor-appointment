class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.references :doctor, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :start_timestamp
      t.datetime :end_timestamp

      t.string :currency, default: 'INR'
      t.decimal :amount
      t.timestamps
    end
  end
end
