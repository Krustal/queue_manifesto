class TaskNode < ActiveRecord::Base
  belongs_to :task_queue
  belongs_to :next_node, class_name: "TaskNode", foreign_key: 'next_node'
  has_one :parent, class_name: "TaskNode", foreign_key: 'next_node'

  def self_and_descendents(depth: 4)
    if next_node && depth > 1
      ([self] << next_node.self_and_descendents(depth: depth - 1)).flatten
    else
      return self
    end
  end
end
