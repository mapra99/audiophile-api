module Webhooks
  module V1
    module Stripe
      class PaymentHandler
        SUCCESS_EVENT = 'payment_intent.succeeded'.freeze
        FAILED_EVENT = 'payment_intent.payment_failed'.freeze

        def initialize(body:)
          self.body = body
        end

        def call
          resolve_event_name
          resolve_payment

          save_event
          dispatch_actions
        end

        private

        attr_accessor :body, :event_name, :payment

        def resolve_event_name
          self.event_name = body['type']
        end

        def resolve_payment
          payment_intent_id = body['data']['object']['id']
          self.payment = Payment.find_by(provider_id: payment_intent_id)
          return if payment.present?

          raise Payments::PaymentNotFound, payment_intent_id
        end

        def save_event
          payment.payment_events.create!(
            event_name: event_name,
            raw_data: body
          )
        rescue ActiveRecord::RecordNotSaved => e
          Rails.logger.error "Could not save event: #{e.message}, payment id: #{payment.id}"
        end

        def dispatch_actions
          case event_name
          when SUCCESS_EVENT
            success_dispatch
          when FAILED_EVENT
            failure_dispatch
          end
        end

        def success_dispatch
          ::Payments::SuccessDispatch.new(payment: payment).call
        end

        def failure_dispatch
          ::Payments::FailureDispatch.new(payment: payment).call
        end
      end
    end
  end
end
