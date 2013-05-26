class TaskNode < ActiveRecord::Base
  belongs_to :task_queue
  belongs_to :next_node, class_name: "TaskNode", foreign_key: 'next_node'
  has_one :parent, class_name: "TaskNode", foreign_key: 'next_node'

  def self_and_descendents
    if next_node
      ([self] << next_node.self_and_descendents).flatten
    else
      return self
    end
  end
end
