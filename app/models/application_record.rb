class ApplicationRecord < ActiveRecord::Base
  include ActiveStorage::SetCurrentOnModel

  self.abstract_class = true
end
