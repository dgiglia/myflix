module Tokenable  
  extend ActiveSupport::Concern
  included do
    before_create :generate_token
    
    def generate_token
      self.token = SecureRandom.urlsafe_base64
    end
    
    def remove_token
      self.update_column(:token, nil)
    end
  end  
end