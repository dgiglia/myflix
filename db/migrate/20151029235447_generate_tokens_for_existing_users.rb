class GenerateTokensForExistingUsers < ActiveRecord::Migration
  def change
    User.find_each do |user|
      user.update_column(:token, SecureRandom.urlsafe_base64)
    end
  end
end
