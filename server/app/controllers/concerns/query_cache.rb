module QueryCache
  extend ActiveSupport::Concern
  included do
    # `cache_query` parses the `q` param from attributes passed into the route.
    def cache_query
      begin
        @q = JSON.parse(params[:q], symbolize_names: true)
      rescue => exception
        return error([:invalid_query_structure])
      end if params[:q]
    end

  end
end
