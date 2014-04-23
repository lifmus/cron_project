class AddScriptType < ActiveRecord::Migration
  def change
    add_column :jobs, :script_type, :string
  end
end
