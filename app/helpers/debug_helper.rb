module DebugHelper
  def debug_queue(queue)
    completed = queue.task_nodes.where('complete IS true')
    in_progress = queue.task_nodes.where('complete IS false')
    render(
      partial: 'debug/queue',
      object: queue,
      locals: {completed: completed, in_progress: in_progress}
    )
  end

  def debug_table(objs)
    objs = [objs].flatten
    obj_class = objs.first.class
    foreign_keys = obj_class.reflections.inject({}) do |memo, (*, relation)|
      memo[relation.foreign_key] = relation.class_name
      memo
    end
    render(
      partial: 'debug/generic_table',
      locals: {objs: objs, obj_class: obj_class, foreign_keys: foreign_keys}
    )
  end
end