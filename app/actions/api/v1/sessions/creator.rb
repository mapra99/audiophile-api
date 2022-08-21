module Api
  module V1
    module Sessions
      class Creator
        include Dry::Monads[:result]

        attr_reader :session

        def initialize(client_ip:)
          self.client_ip = client_ip
        end

        def call
          create_session

          Success(session)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_writer :session
        attr_accessor :client_ip

        def create_session
          self.session = Session.create!(ip_address: client_ip)
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :invalid_session, message: e.message })
        end
      end
    end
  end
end
