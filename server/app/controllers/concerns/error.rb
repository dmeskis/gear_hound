module Error
  extend ActiveSupport::Concern
  included do
    include ErrorHelper
    def error(errors, return_errors = false)
      return unless errors.is_a?(Array)
      response_json, status_code = { errors: [], meta: { error_count: 0 } }, nil

      # Errors can be sent to the render engine in 3 different formats. 1) As a string literal key,
      # 2) As an active record model, 3) As a custom 1-off error object. The following block introspects
      # the cases being passed in and compiles a final errors array to be rendered to the payload.

      errors.each do |obj|

        # Case for active record objects

        if obj.is_a?(ApplicationRecord)
          error = get_error(:validation_error)
          status_code = status_code.blank? ? error[:status] : status_code
          obj.errors.each do |attribute, message|
            response_json[:meta][:error_count] += 1
            response_json[:meta][:details] = obj.errors.details if obj.errors.details
            response_json[:errors] << build_error(error[:status], error[:code], attribute, message)
          end

        # Case for error objects or error string literal keys

        else
          error = obj.class == Hash ? obj : get_error(obj)
          status_code = status_code.blank? ? error[:status] : status_code
          response_json[:meta][:error_count] += 1
          response_json[:errors] << build_error(error[:status], error[:code], error[:title], error[:detail])
        end
      end

      # Depending on the use case a controller may just need the error objects which will be rendered later.
      return response_json[:errors] if return_errors

      # Once all of the error data are compiled it can just be rendered to the payload.

      return render json: response_json, status: status_code
    end

    private
    def build_error(status, code, title, detail)
      {
        status: status || nil,
        code: code || nil,
        title: title || nil,
        detail: detail || nil
      }
    end
  end
end
