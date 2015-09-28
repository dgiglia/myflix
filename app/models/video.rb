class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> {order("created_at DESC")}
  has_many :queue_items
  
  validates :title, presence: true, uniqueness: true
  validates_presence_of :description
  
  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title ILIKE ?", "%#{search_term}%").order("title ASC")
  end
  
  def average_rating
    return 0 if reviews.empty?
    reviews.average(:rating).round(1)
  end  
end