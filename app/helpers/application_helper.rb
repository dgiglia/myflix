module ApplicationHelper
  def rating_options
    ((1..5).map { |rating| [pluralize(rating, "Star")]})
  end
end
