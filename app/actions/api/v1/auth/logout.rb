module Api
  module V1
    module Auth
      class Logout
        include Dry::Monads[:result]

        def initialize(user:, access_token:)
          self.user = user
          self.access_token = access_token
        end

        def call
          revoke_token
          kill_revoker_job

          Success(access_token)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_accessor :user, :access_token

        def revoke_token
          Authentication::AccessTokens::Revoker.new(access_token: access_token).call
        end

        def kill_revoker_job
          Authentication::AccessTokens::RevokerJob.kill!(access_token.expiration_job_id)
        end
      end
    end
  end
end
