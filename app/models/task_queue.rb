class TaskQueue < ActiveRecord::Base
  belongs_to :user
  has_many :task_nodes

  def enqueue(task_node)
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

  def dequeue(task_node)
    parent_node = begin 
      self.task_nodes.where(next_node: task_node.id).limit(1).first
    rescue
      nil
    end
    next_node_id = task_node.next_node
    binding.pry
    # set the queue front pointer to this element's next node
    # if it has one.
    if self.front == task_node.id
      self.front = next_node_id
    end
    # set the queue back pointer to the element that has this
    # element as a next node, if there is one.
    if self.back == task_node.id
      self.back = parent_node.id
    end
    # connect this nodes parent and child if they exist
    if parent_node
      parent_node.next_node = next_node_id
    end
    # save our changes to the records effected on the side
    if self.save! && (parent_node.nil? || parent_node.save!)
      task_node.destroy
      return true
    else
      return false
    end
  end
end
