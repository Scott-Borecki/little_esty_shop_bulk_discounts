class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def formatted_time
    created_at.strftime('%A, %B %-d, %Y')
  end
end
