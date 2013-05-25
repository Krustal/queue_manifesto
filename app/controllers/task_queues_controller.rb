class TaskQueuesController < ApplicationController
  before_action :set_task_queue, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index]

  # GET /task_queues
  # GET /task_queues.json
  def index
    if user_signed_in?
      user_index
    else
      splash_index
    end
  end

  def user_index
    @task_queues = TaskQueue.all
  end

  def splash_index
    render action: :splash_index
  end

  # GET /task_queues/1
  # GET /task_queues/1.json
  def show
  end

  # GET /task_queues/new
  def new
    @task_queue = TaskQueue.new
  end

  # GET /task_queues/1/edit
  def edit
  end

  # POST /task_queues
  # POST /task_queues.json
  def create
    @task_queue = TaskQueue.new(task_queue_params)

    respond_to do |format|
      if @task_queue.save
        format.html { redirect_to @task_queue, notice: 'Task queue was successfully created.' }
        format.json { render action: 'show', status: :created, location: @task_queue }
      else
        format.html { render action: 'new' }
        format.json { render json: @task_queue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_queues/1
  # PATCH/PUT /task_queues/1.json
  def update
    respond_to do |format|
      if @task_queue.update(task_queue_params)
        format.html { redirect_to @task_queue, notice: 'Task queue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task_queue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_queues/1
  # DELETE /task_queues/1.json
  def destroy
    @task_queue.destroy
    respond_to do |format|
      format.html { redirect_to task_queues_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_queue
      @task_queue = TaskQueue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_queue_params
      params.require(:task_queue).permit(:user_id, :name)
    end
end
