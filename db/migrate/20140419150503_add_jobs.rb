class AddJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string   :frequency
      t.integer  :minute
      t.integer  :hour
      t.integer  :day_of_month
      t.integer  :month
      t.integer  :day_of_week
      t.text     :script
      t.datetime :latest_run

      t.timestamps
    end
  end
end
