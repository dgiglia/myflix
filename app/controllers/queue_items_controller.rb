class QueueItemsController < ApplicationController
  before_action :require_user
  
  def index
    @queue_items = current_user.queue_items
  end
  
  def create
    @video = Video.find(params[:video_id])
    QueueItem.create(video: @video, user: current_user, position: new_queue_item_position) unless queue_item_exists? 
    redirect_to my_queue_path
  end
  
  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if queue_item.user == current_user
    current_user.normalize_queue_positions
    redirect_to my_queue_path
  end
  
  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_positions
    rescue ActiveRecord::RecordInvalid
      flash['danger'] = "Invalid list order. Must use integers."
    end        
    redirect_to my_queue_path
  end
  
  private
  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |data|
        item = QueueItem.find(data["id"])
        item.update_attributes!(position: data["position"], rating: data["rating"]) if item.user == current_user
      end
    end
  end
  
  def new_queue_item_position
    current_user.queue_items.count + 1
  end
  
  def queue_item_exists?
    current_user.queue_items.map(&:video).include?(@video)
  end
end