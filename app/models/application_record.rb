class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def format_created_at
    created_at.strftime("%A, %B %d, %Y")
  end
end
