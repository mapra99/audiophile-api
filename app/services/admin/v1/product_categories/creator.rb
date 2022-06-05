module Admin
  module V1
    module ProductCategories
      class Creator
        include Dry::Monads[:result]

        attr_reader :params, :product_category

        def initialize(params:)
          self.params = params
        end

        def call
          build_product_category
          attach_image
          save_product_category
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure(:internal_error)
        end

        private

        attr_writer :params, :product_category

        def build_product_category
          self.product_category = ProductCategory.new(
            name: params[:name]
          )
        end

        def attach_image
          product_category.image.attach(params[:image])
        end

        def save_product_category
          product_category.save!
          Success(product_category)
        rescue ActiveRecord::RecordNotSaved => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :product_category_not_saved })
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error(e)
          raise ServiceError,
                Failure({ code: :invalid_product_category, message: product_category.errors.full_messages })
        end
      end
    end
  end
end
