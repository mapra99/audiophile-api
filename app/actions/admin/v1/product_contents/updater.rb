module Admin
  module V1
    module ProductContents
      class Updater
        include Dry::Monads[:result]

        attr_reader :params, :product_content

        def initialize(params:)
          self.params = params
        end

        def call
          find_product_content
          attach_files_or_value

          Success(product_content)
        rescue ServiceError => e
          e.failure
        rescue StandardError => e
          Rails.logger.error(e)
          Failure({ code: :internal_error })
        end

        private

        attr_writer :params, :product_content

        def find_product_content
          self.product_content = ProductContent.find_by!(
            key: params[:key],
            product_id: params[:product_id]
          )
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error(e)
          raise ServiceError, Failure({ code: :product_content_not_found })
        end

        def attach_files_or_value
          if params[:content].is_a? String
            product_content.update!(value: params[:content])
          else
            product_content.files.purge
            product_content.files.attach(params[:content])
          end
        end
      end
    end
  end
end
