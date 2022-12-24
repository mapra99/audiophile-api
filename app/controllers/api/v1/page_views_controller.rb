module Api
  module V1
    class PageViewsController < BaseController
      skip_before_action :authenticate_user_by_token!
      before_action :authenticate_session_by_header!

      def create
        creator = Api::V1::PageViews::Creator.new(
          session: current_session,
          params: page_view_params
        )
        result = creator.call
        return render_error_from(result) if result.failure?

        @user_location = result.value!
      end

      private

      def page_view_params
        params.permit(:page_path, :query_params)
      end
    end
  end
end
