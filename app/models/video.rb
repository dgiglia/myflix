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
      reviews.average(:rating).round(1) if reviews.average(:rating)
  end  
  
  def self.search(query, options={})
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: ['title^100', 'description^50'],
          operator: 'and'
        }
      }
    }

    if query.present? && options[:reviews]
      search_definition[:query][:multi_match][:fields] << 'reviews.comment'
    end

    if options[:average_rating_from].present? || options[:average_rating_to].present?
      search_definition[:filter] = {
        range: {
          average_rating: {
            gte: (options[:average_rating_from] if options[:average_rating_from].present?),
            lte: (options[:average_rating_to] if options[:average_rating_to].present?)
          }
        }
      }
    end
    
    __elasticsearch__.search(search_definition)
  end
  
  def as_indexed_json(options={})
    as_json(
      methods: [:average_rating],
      only: [:title, :description],
      include: {
        reviews: { only: [:comment] }
      }
    )
  end
end