module ActiveStorage
  module SetCurrentOnModel
    extend ActiveSupport::Concern

    included do
      after_initialize do
        ActiveStorage::Current.host = ENV['HOST_URL']
      end
    end
  end
end
