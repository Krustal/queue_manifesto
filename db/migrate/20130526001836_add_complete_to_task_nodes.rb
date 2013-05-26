class AddCompleteToTaskNodes < ActiveRecord::Migration
  def change
    add_column :task_nodes, :complete, :boolean, :default => false
  end
end
