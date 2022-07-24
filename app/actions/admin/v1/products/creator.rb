module Admin
  module V1
    module Products
      class Creator
        include Dry::Monads[:result]

        attr_reader :params, :product

        def initialize(params:)
          self.params = params
        end

        def call
          build_product
          attach_image
          find_and_set_category
          save_product
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_writer :params, :product

        def build_product
          self.product = Product.new(
            name: params[:name],
            base_price: params[:price],
            featured: params[:featured]
          )
        end

        def attach_image
          product.image.attach(params[:image])
        end

        def find_and_set_category
          category = ProductCategory.find(params[:category_id])
          product.product_category = category
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :category_not_found })
        end

        def save_product
          product.save!
          Success(product)
        rescue ActiveRecord::RecordNotSaved => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :product_not_saved })
        rescue ActiveRecord::RecordInvalid => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :invalid_product, message: product.errors.full_messages })
        end
      end
    end
  end
end
