class TaskQueue < ActiveRecord::Base
  belongs_to :user
  has_many :task_nodes

  def push(task_node)
    if front.nil? && back.nil?
      self.front = task_node.id
      self.back = task_node.id
      if self.save!
        return true
      end
    else
      old_back = self.task_nodes.find(self.back)
      old_back.next_node = task_node.id
      self.back = task_node.id
      if old_back.save && save
        return true
      else
        return false
      end
    end
    return false
  end
end
