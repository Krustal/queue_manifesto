json.array!(@task_queues) do |task_queue|
  json.extract! task_queue, :user_id, :name
  json.url task_queue_url(task_queue, format: :json)
end