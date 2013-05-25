json.array!(@task_nodes) do |task_node|
  json.extract! task_node, :title, :description, :next_node, :task_queue_id
  json.url task_node_url(task_node, format: :json)
end