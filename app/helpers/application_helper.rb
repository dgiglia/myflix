module ApplicationHelper
  def rating_options(selected=nil)
    options_for_select((1..5).map { |rating| [pluralize(rating, "Star"), rating]}, selected)
  end
end
