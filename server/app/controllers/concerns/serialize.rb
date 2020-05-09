module Serialize
  include ActiveSupport::Concern

  def serialize(args)
    json = {}
    plurality, key = plurality?(args[:model])

    # This will need to be extended to pass API options in like filters or other options

    json[key] = compile_models(args[:model], plurality)

    # Compile metadata and return
    json = set_meta(json)

    # Include any includes data if present
    json = add_include(json) unless @include.blank?

    # Return the final json payload now that it has finished rendering to objects. Note that the return
    # of this function is an object and not actual JSON. Rails will render the JSON to string for us.
    json
  end

  def serialize_plural(args = {})
    # args[:data] should contain an array of hashes that contain a model and serializer
    # Ex: { data: [{model: @model, serializer: API::V1::ModelSerializer}] }
    # Where @model is a singular or collection of models
    json = {}

    args[:data].each do |m|
      plurality, key = plurality?(m[:model])

      @SERIALIZER = m[:serializer]
      @MODEL = plurality ? m[:model].first.class : m[:model].class

      json[key] = compile_models(m[:model], plurality)
    end

    # TODO Need to set metadata

    json
  end

  def serialize_es
    json = {}

    # Parse the ES response into a final object to be returned

    @models.each do |result|

      # Determine the key the response should be returned in
      key = @META[:split_response] ? result._index.to_sym : :results

      # If the key is empty then initialize it
      json[key] = [] unless json[key]

      # Grab the source from the ES result
      source = result._source

      # Add additional metadata about the result unless we are skipping adverse data
      unless @adverse_scrub
        source[:_index] = result._index
        source[:_score] = result._score
      end

      # Add the final object to the payload
      json[key] << source
    end

    # Compile metadata and return
    json = set_meta(json)
    json
  end

  private
  def set_meta(json)
    compile_meta
    json[:meta] = @META
    json
  end

  def compile_meta
    @META = @META ? @META : {}

    # Pagination
    @META[:page] = @page if @page
    @META[:per_page] = @per_page if @per_page
    @META[:total_pages] = @models.total_pages if @models
    @META[:total_entries] = @models.total_entries if @models

    # Errors
    @META[:error_count] = @errors.length unless @errors.blank?

    # Scrub any adverse data
    if @adverse_scrub
      @META.delete(:admin)
      @META.delete(:find_company)
      @META.delete(:split_response)
    end
  end

  def compile_model(model)
    serializer_attrs = {model: @MODEL, params: params}
    serializer_attrs[:custom] = @custom_serializer_attrs if @custom_serializer_attrs
    serialized_model = @SERIALIZER.new(model, serializer_attrs)
    return @custom_attrs.blank? ? serialized_model : compile_custom_attrs!(serialized_model)
  end

  def compile_models(model, plurality)
    plurality ? model.map { |x| compile_model(x) } : compile_model(model)
  end

  def plurality?(model)
    # This will determine whether the model passed in is a list of models of some kind or not
    # and set the key appropriately
    plurality = model.is_a?(Array) || model.is_a?(ActiveRecord::Relation) || model.is_a?(Elasticsearch::Model::Response::Results) || model.is_a?(Elasticsearch::Model::Response::Records)
    key = plurality ? :"#{model.first.model_name.route_key}" : :"#{model.model_name.singular_route_key}"
    [plurality, key]
  end
end
