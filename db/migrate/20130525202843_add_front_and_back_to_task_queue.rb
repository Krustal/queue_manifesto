class AddFrontAndBackToTaskQueue < ActiveRecord::Migration
  def change
    add_column :task_queues, :front, :integer
    add_column :task_queues, :back, :integer
  end
end
