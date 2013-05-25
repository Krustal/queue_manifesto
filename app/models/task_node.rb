class TaskNode < ActiveRecord::Base
  belongs_to :task_queue
end
