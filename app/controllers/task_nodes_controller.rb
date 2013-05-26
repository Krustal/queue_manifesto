class TaskNodesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task_queue
  before_action :set_task_node, only: [:show, :edit, :update, :destroy, :requeue, :complete]

  # GET /task_nodes
  # GET /task_nodes.json
  def index
    @task_nodes = @task_queue.task_nodes
  end

  # GET /task_nodes/1
  # GET /task_nodes/1.json
  def show
  end

  # GET /task_nodes/new
  def new
    @task_node = TaskNode.new
  end

  # GET /task_nodes/1/edit
  def edit
  end

  # POST /task_nodes
  # POST /task_nodes.json
  def create
    @task_node = @task_queue.task_nodes.build(task_node_params)

    respond_to do |format|
      if @task_node.save
        if @task_queue.enqueue(@task_node)
          format.html { redirect_to task_queue_task_node_path(@task_queue, @task_node), notice: 'Task node was successfully created.' }
          format.json { render action: 'show', status: :created, location: @task_node }
        else
          @task_node.destroy
          format.html do
            redirect_to(
              new_task_queue_task_node_path(@task_queue),
              alert: "couldn't push task onto queue"
            )
          end
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @task_node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_nodes/1
  # PATCH/PUT /task_nodes/1.json
  def update
    respond_to do |format|
      if @task_node.update(task_node_params)
        format.html do 
          redirect_to(
            task_queue_task_node_path(@task_queue, @task_node), 
            notice: 'Task node was successfully updated.'
          ) 
        end
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task_node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /task_queues/1/task_nodes/1/complete
  def complete
    if @task_queue.front == @task_node.id
      @task_queue.dequeue(@task_node)
      @task_node.complete = true
      @task_node.next_node = nil
      if @task_node.save!
        respond_to do |format|
          format.html do 
            redirect_to(
              task_queue_task_nodes_path(@task_queue),
              notice: 'task completed'
            ) 
          end
        end
      end
    else
      redirect_to(
        task_queue_task_nodes_path(@task_queue),
        alert: 'There was a problem completing the task'
      )
    end
  end

  # PUT /task_queues/:task_queue/task_nodes/1/requeue
  def requeue
    if @task_queue.front == @task_node.id
      @task_queue.dequeue(@task_node)
      @task_queue.enqueue(@task_node)
      @task_node.next_node = nil
      @task_node.save!
      respond_to do |format|
        format.html { redirect_to task_queue_task_nodes_path(@task_queue) }
        format.json { head :no_content }
      end
    else
      redirect_to(
        task_queue_task_nodes_path(@task_queue), 
        alert: "Can't requeue an item that isn't in the front"
      )
    end
  end

  # DELETE /task_nodes/1
  # DELETE /task_nodes/1.json
  def destroy
    if @task_queue.dequeue(@task_node)
      @task_node.destroy
    end
    respond_to do |format|
      format.html { redirect_to task_queue_task_nodes_path(@task_queue) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_queue
      @task_queue = current_user.task_queues.find(params[:task_queue_id])
    rescue
      redirect_to :root, alert: "You don't have a queue with that name"
    end

    def set_task_node
      @task_node = @task_queue.task_nodes.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :root, alert: "You don't have that task on that queue"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_node_params
      params.require(:task_node).permit(:title, :description, :next_node, :task_queue_id)
    end
end
