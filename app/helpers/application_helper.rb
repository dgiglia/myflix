module ApplicationHelper
  def rating_options(selected=nil)
    options_for_select((1..5).map { |rating| [pluralize(rating, "Star"), rating]}, selected)
  end
  
  def gravatar_for(user)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}?s=40"
  end
end
