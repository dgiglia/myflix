class VideosController < ApplicationController
  before_action :require_user
  
  def index
    @categories = Category.all 
  end
  
  def show
    @video = VideoDecorator.decorate(Video.find(params[:id]))
    @reviews = @video.reviews
  end
  
  def search
    @results = Video.search_by_title(params[:search_term])
  end
  
  def advanced_search
    options = {
      reviews: params[:reviews],
      average_rating_from: params[:average_rating_from],
      average_rating_to: params[:average_rating_to]
    }
    if params[:query]
      @videos = Video.search(params[:query], options).records.to_a
    else
      @videos = []
    end  
  end
end