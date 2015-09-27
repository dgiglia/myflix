class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  
  validates_presence_of :email, :password, :name
  validates_uniqueness_of :email 
end