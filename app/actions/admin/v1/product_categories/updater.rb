module Admin
  module V1
    module ProductCategories
      class Updater
        include Dry::Monads[:result]

        attr_reader :product_category

        def initialize(category_id:, params:)
          self.category_id = category_id
          self.params = params
        end

        def call
          find_product_category
          update_product_category
          attach_image

          Success(product_category)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_writer :product_category
        attr_accessor :category_id, :params

        def find_product_category
          self.product_category = ProductCategory.find(category_id)
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :category_not_found })
        end

        def update_product_category
          product_category.update!(
            name: params[:name]
          )
        end

        def attach_image
          product_category.image.purge
          product_category.image.attach(params[:image])
        end
      end
    end
  end
end
