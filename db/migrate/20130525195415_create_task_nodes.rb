class CreateTaskNodes < ActiveRecord::Migration
  def change
    create_table :task_nodes do |t|
      t.string :title
      t.text :description
      t.integer :next_node
      t.integer :task_queue_id

      t.timestamps
    end
  end
end
