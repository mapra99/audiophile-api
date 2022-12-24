module Admin
  module V1
    module Products
      class Updater
        include Dry::Monads[:result]

        attr_reader :product

        def initialize(product_id:, params:)
          self.product_id = product_id
          self.params = params
        end

        def call
          find_product
          update_product_attributes
          update_image

          Success(product)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_writer :product
        attr_accessor :product_id, :params

        def find_product
          self.product = Product.find(product_id)
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :product_not_found })
        end

        def update_product_attributes
          product.update!(
            name: params[:name],
            base_price: params[:price],
            featured: params[:featured],
            product_category_id: params[:category_id]
          )
        end

        def update_image
          product.image.purge
          product.image.attach(params[:image])
        end
      end
    end
  end
end
