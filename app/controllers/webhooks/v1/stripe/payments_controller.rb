module Webhooks
  module V1
    module Stripe
      class PaymentsController < BaseController
        def create
          payment_handler.call

          head :ok
        rescue StandardError => e
          Rails.logger.error(e)

          head :ok
        end

        private

        def request_body
          @request_body ||= JSON.parse(request.body.string)
        end

        def payment_handler
          @payment_handler ||= Webhooks::V1::Stripe::PaymentHandler.new(body: request_body)
        end
      end
    end
  end
end
