module Query
  extend ActiveSupport::Concern
  included do
    before_action :cache_parameter_keys, :cache_model_payload, only: [:create, :update, :destroy, :batch_create, :batch_update, :batch_destroy]
    before_action :require_show_params, only: [:show]
    before_action :require_index_params, :cache_query_params, :query_plural, only: [:index]
    before_action :query_singular, :not_found, only: [:show, :update, :destroy]
    before_action :cache_batch_models, only: [:batch_update, :batch_destroy]
    before_action :should_reindex_wait, only: [:create, :update, :delete, :batch_update, :batch_destroy]

    def query_singular
      @model = load_single(params[:id])
    end

    def query_plural
      if @MODEL.method_defined? :es?

        # Integrate universal ES query system here...
        search_obj = {}

        @models = @MODEL.query({query: search_obj, page: @page, per_page: @per_page})
      else
        @models = @MODEL.all.paginate(page: @page, per_page: @per_page)
      end
    end

    def cache_batch_models
      @batch_models = []
      @model_payload.each do |attrs|
        model = @MODEL.find_by_id(attrs[:id])
        attr_params = ActionController::Parameters.new(attrs)
        model_cache = {model: model, attrs: permit_params(attr_params)} if model && attr_params
        @batch_models << model_cache if model_cache
      end
    end

    def load_single(id)
      if id == "find" && @q && @q[:find_by]
        return error([:invalid_find_by_query]) if @q[:find_by].empty?
        @MODEL.find_by(@q[:find_by])
      else
        @MODEL.find_by(id: id)
      end
    end

    def cache_parameter_keys
      @singular_key = :"#{@MODEL.model_name.singular_route_key}"
      @plural_key = :"#{@MODEL.model_name.route_key}"
      @param_key = params[@plural_key].blank? ? @singular_key : @plural_key
      @BATCH_QUERY = @param_key == @plural_key
    end

    def cache_model_payload
      return error([:invalid_query_structure]) if @BATCH_QUERY && !params[@param_key].is_a?(String)
      @model_payload = TextHelper.valid_json?(params[@param_key]) || params[@param_key]
    end

    def should_reindex_wait
      if @BATCH_QUERY
        # Set reindex wait on the last model to be updated
        @batch_models.last[:model].index_should_wait = true if @REINDEX_WAIT && @batch_models.last[:model]
      else
        @model.index_should_wait = true if @REINDEX_WAIT && @model
      end
    end

    private
    def cache_query_params
      # Pagination
      @page = params[:page] && params[:page].to_i > 0 ? params[:page].to_i : 1
      @per_page = params[:per_page] ? params[:per_page].to_i.clamp(1, 100) : 25

      # Filter
      @filter = params[:filter].is_a?(ActionController::Parameters) ? params[:filter].to_h : nil
      @filter.delete_if { |k, v| v.empty? || v == 'NaN' || v.blank? } if @filter

      # Sort
      @sort = params[:sort].is_a?(ActionController::Parameters) ? params[:sort].to_h : nil
      @sort.delete_if { |k, v| v.empty? || v == 'NaN' || v.blank? } if @sort
    end

    def require_show_params
      require_param_chain @SHOW_REQUIRED if @SHOW_REQUIRED
    end

    def require_index_params
      require_param_chain @INDEX_REQUIRED if @INDEX_REQUIRED
    end

    def require_param_chain(chain)
      chain.each do |required|
        step = params
        required.each do |attribute|
          step = step[attribute]
          return error([:missing_request_param]) unless step
        end
      end
    end
  end
end
