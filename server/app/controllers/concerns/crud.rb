module Crud
  extend ActiveSupport::Concern
  included do
    before_action :cache_context_options, :cache_helper_variables, :cache_query, :parse_custom_attrs
    include QueryCache
    include CustomAttributes
    include Query
    include Serialize
    include Include

    # Context Variables
    # @MODEL = Keyblade
    # @SERIALIZER = API::V1::KeybladeSerializer
    # @PARAMS = [:name, :str, :mp]
    # @META = {}

    # before_action callbacks for route process
    before_action :require_model_params, only: [:create, :update, :batch_create, :batch_update]
    before_action :can_perform_read?, only: [:show]
    before_action :can_perform_create?, only: [:create, :batch_create]
    before_action :can_perform_write?, only: [:update, :destroy, :batch_update, :batch_destroy]
    before_action :before_index, :perform_index, only: [:index]
    before_action :before_show, :perform_show, only: [:show]
    before_action :set_index_should_wait, only: [:create, :update, :destroy]
    before_action :before_write, only: [:create, :update, :destroy]
    before_action :before_upsert, only: [:create, :update, :batch_create, :batch_update]
    before_action :before_create, only: [:create, :batch_create]
    before_action :perform_create, only: [:create]
    before_action :perform_batch_create, only: [:batch_create]
    before_action :after_create, only: [:create, :batch_create]
    before_action :before_modify, only: [:update, :destroy, :batch_update, :batch_destroy]
    before_action :before_update, only: [:update, :batch_update]
    before_action :perform_update, only: [:update]
    before_action :perform_batch_update, only: [:batch_update]
    before_action :after_update, only: [:update, :batch_update]
    before_action :after_upsert, only: [:create, :update, :batch_create, :batch_update]
    before_action :before_destroy, only: [:destroy, :batch_destroy]
    before_action :perform_destroy, only: [:destroy]
    before_action :perform_batch_destroy, only: [:batch_destroy]
    before_action :after_destroy, only: [:destroy, :batch_destroy]
    before_action :cache_edited_models, only: [:batch_update, :batch_create]
    before_action :include_extension, only: [:show]
    before_action :before_render, :render_json

    # CRUD route bound functions
    def index ;end
    def show ;end
    def create ;end
    def update ;end
    def destroy ;end
    def batch_create ;end
    def batch_update ;end
    def batch_destroy;end

    # Callback events which controllers will override
    def before_index ;end
    def before_show ;end
    def before_create ;end
    def after_create ;end
    def before_update ;end
    def after_update ;end
    def before_destroy ;end
    def after_destroy ;end
    def before_render ;end
    def before_modify ;end
    def before_write ;end
    def before_upsert ;end
    def after_upsert ;end

    private
    def perform_index
      @STATUS = 200
    end

    def perform_show
      @STATUS = 200
    end

    def perform_create
      @model = @MODEL.new(permit_params(@model_payload))
      return error([@model]) unless @model.save
      @STATUS = 201
    end

    def perform_update
      return error([@model]) unless @model.update(permit_params(@model_payload))
      @STATUS = 200
    end

    def perform_destroy
      @model.destroy
      @STATUS = :no_content
    end

    def perform_batch_create
      @models_edited = []
      @model_payload.each do |attrs|
        model = @MODEL.new(attrs)
        if model.save
          @models_edited << model
        else
          @errors << error([model], true)
        end
      end
      @STATUS = 201
    end

    def perform_batch_update
      @models_edited = []
      @batch_models.each do |model_cache|
        if model_cache[:model]
          if model_cache[:model].update(model_cache[:attrs])
            @models_edited << model_cache[:model]
          else
            @errors << error([model_cache[:model]], true)
          end
        else
          @errors << error([:not_found], true)
        end
      end
      @STATUS = 200
    end

    def perform_batch_destroy
      @batch_models.each do |model_cache|
        model_cache[:model].destroy if model_cache[:model]
      end
      @STATUS = :no_content
    end

    def cache_edited_models
      return error([:batch_action_failed]) if @models_edited.blank?
      @models = @MODEL.where(id: @models_edited.map{|m| m.id}).paginate(page: 1, per_page: 1000)
    end

    def render_json
      return head :no_content if @STATUS == :no_content
      payload = {}
      if @errors.blank?
        payload[:model] = @models || @model
      else
        payload[:errors] = @errors
      end
      render json: serialize(payload), status: @STATUS || 200
    end

    def permit_params(attrs)
      attrs.permit(@PARAMS + [:index_should_wait])
    end

    def not_found
      return error([:not_found]) if !@plural_singular_state && !@model
    end

    def require_model_params
      return error([:missing_request_param]) if @model_payload.blank?
    end

    def cache_helper_variables
      @errors = []
    end

    def set_index_should_wait
      return @model_payload[:index_should_wait] = true if @REINDEX_WAIT && !@model_payload.blank?
      return @model.update(index_should_wait: true) if @REINDEX_WAIT && !@model.blank?
    end
  end
end
