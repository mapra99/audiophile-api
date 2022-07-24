module Admin
  module V1
    module ProductContents
      class Creator
        include Dry::Monads[:result]

        attr_reader :params, :product_content

        def initialize(params:)
          self.params = params
        end

        def call
          validate_params
          build_product_content
          find_and_set_product
          attach_files_or_value
          save_product_content
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_writer :params, :product_content

        def validate_params
          raise ServiceError, Failure({ code: :wrong_params, message: 'key must be provided' }) if params[:key].blank?
          if params[:product_id].blank?
            raise ServiceError, Failure({ code: :wrong_params, message: 'product_id must be provided' })
          end
          return if params[:content].present?

          raise ServiceError, Failure({ code: :wrong_params, message: 'content must be provided' })
        end

        def build_product_content
          self.product_content = ProductContent.new(
            key: params[:key]
          )
        end

        def find_and_set_product
          product = Product.find(params[:product_id])
          product_content.product = product
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :product_not_found })
        end

        def attach_files_or_value
          if params[:content].is_a? String
            product_content.value = params[:content]
          else
            product_content.files.attach(params[:content])
          end
        end

        def save_product_content
          product_content.save!
          Success(product_content)
        rescue ActiveRecord::RecordNotSaved => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :product_content_not_saved })
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error(e)
          raise ServiceError,
                Failure({ code: :invalid_product_content, message: product_content.errors.full_messages })
        end
      end
    end
  end
end
