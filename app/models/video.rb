class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ["myflix", Rails.env].join'_'
  
  belongs_to :category
  has_many :reviews, -> {order("created_at DESC")}
  has_many :queue_items
  
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  
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
  
  def as_indexed_json(options={})
    as_json(only: [:title, :description])
  end
  
  def self.search(query)
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: [:title, :description],
          operator: "and"
        }
      }
    }
    __elasticsearch__.search(search_definition)
  end
end