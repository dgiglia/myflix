class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items, -> {order("position")}
  
  validates_presence_of :email, :password, :name
  validates_uniqueness_of :email 
  
  def normalize_queue_positions
    queue_items.each_with_index do |q, i|
      q.update_attributes(position: i+1)
    end
  end
end