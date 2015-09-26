class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews
  
  validates :title, presence: true, uniqueness: true
  validates_presence_of :description
  
  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title ILIKE ?", "%#{search_term}%").order("title ASC")
  end
  
  def average_rating
    return 0 if reviews.empty?
    ratings = []
    reviews.each do |review|
      ratings << review.rating
    end
    ratings.sum / ratings.count
  end
end