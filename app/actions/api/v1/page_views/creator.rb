module Api
  module V1
    module PageViews
      class Creator
        include Dry::Monads[:result]

        attr_reader :page_view

        def initialize(session:, params:)
          self.session = session
          self.params = params
        end

        def call
          create_page_view

          Success(page_view)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_writer :page_view
        attr_accessor :session, :params

        def create_page_view
          self.page_view = session.page_views.create!(params)
        end
      end
    end
  end
end
