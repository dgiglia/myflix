class VideosController < ApplicationController
  
  def index
    @categories = Category.all 
  end
  
  def new
    @video = Video.new
  end
  
  def show
    @video = Video.find(params[:id])
  end
  
  def create
    @video = Video.new(video_params)
  end
  
  private
  def video_params
    params.require(:video).permit!
  end
  
end