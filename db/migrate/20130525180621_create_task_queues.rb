class CreateTaskQueues < ActiveRecord::Migration
  def change
    create_table :task_queues do |t|
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end
end
