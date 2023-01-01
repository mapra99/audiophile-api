module Api
  module V1
    module Payments
      class Finder
        include Dry::Monads[:result]

        attr_reader :payment

        def initialize(payment_uuid:, user:)
          self.payment_uuid = payment_uuid
          self.user = user
        end

        def call
          result = user.payments.find_by!(uuid: payment_uuid)

          self.payment = result
          Success(result)
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          Failure({ code: :payment_not_found, message: "Payment with uuid #{payment_uuid} not found" })
        end

        private

        attr_accessor :payment_uuid, :user
        attr_writer :payment
      end
    end
  end
end
