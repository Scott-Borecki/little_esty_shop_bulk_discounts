class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Returns the date in the format of: Monday, August 9, 2021.
  def formatted_date
    created_at.strftime('%A, %B %-d, %Y')
  end
end
