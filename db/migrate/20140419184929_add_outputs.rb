class AddOutputs < ActiveRecord::Migration
  def change
    create_table :outputs do |t|
      t.text    :text
      t.integer :job_id
      t.boolean :success

      t.timestamps
    end
  end
end
