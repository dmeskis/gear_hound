module Include
  extend ActiveSupport::Concern
  included do
    # `include_extension` is run as a callback before render on wherever it's integrated. This should return
    # an error if an error is hit, otherwise it should compile an include object.
    def include_extension
      if @model && @q && @q[:include]
        status = perform_include_error_checks; return error([status]) unless status
        perform_include_lookups
      end
    end

    # `add_include` will take any regular hash object and add any @include data cached to it.
    def add_include(payload)
      return if @include.blank? || payload.blank?
      @include.each{|i| payload[i[:key]] = i[:value] }
      payload
    end

    private
    # `include_lookup_types` defines the patterns of lookup allowed in the include system.
    def include_lookup_types
      ["relation"]
    end

    # `perform_include_error_checks` inspects the include object and errors if anything is out of order.
    def perform_include_error_checks
      return :invalid_include_object_structure if !@q[:include].has_key?(:models) || !@q[:include][:models].is_a?(Array) || @q[:include][:models].length < 1
      @q[:include][:models].each do |model|
        return :invalid_include_model_structure unless model.has_key?(:lookup_type)
        return :invalid_include_lookup_type unless model[:lookup_type].in?(include_lookup_types)
        if model[:lookup_type] == "relation"
          return :invalid_include_model_structure unless model.has_key?(:key)
        end
      end
      return true
    end

    # `perform_include_lookups` will cycle through the include lookups and route them to the proper lookup function.
    def perform_include_lookups
      @include = []
      @q[:include][:models].each do |model|
        include_relation_lookups(model) if model[:lookup_type] == "relation"
      end
    end

    # `include_relation_lookups` performs the model lookups for the `relation` lookup pattern. Basically that just means
    # it grabs data from real relations on the already cached @model.
    def include_relation_lookups(model)
      relation = @model.send(model[:key])

      unless relation.blank?
        is_has_many_relation = relation.class.name == "ActiveRecord::Associations::CollectionProxy"
        model_type = is_has_many_relation ? relation.try(:name) : relation.is_a?(Array) ? relation.first.class.name : relation.class.name
        serializer = Object.const_get "API::V1::#{model_type}Serializer"
        value = is_has_many_relation || relation.is_a?(Array) ? relation.map{|r| serializer.new(r).serializable_hash } : serializer.new(relation).serializable_hash
      end

      @include << {
        key: model[:key],
        value: value || relation
      }
    end
  end
end
