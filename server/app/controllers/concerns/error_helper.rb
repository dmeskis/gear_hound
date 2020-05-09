module ErrorHelper
  def get_error(key)
    ErrorHelper::ERRORS[key]
  end

  # All error definitions for the application

  ERRORS = {
    validation_error: {
      status: 406,
      code: 0,
      title: "Reserved Code",
      detail: "0 is the reserved code for all ActiveRecord attribute validation errors."
    },
    not_found: {
      status: 404,
      code: 1,
      title: "File Not Found",
      detail: "Sorry, the content you are seeking does not exist."
    },
    missing_request_param: {
      status: 406,
      code: 2,
      title: "Missing Request Param",
      detail: "Missing request param, unable to complete request."
    },
    unauthorized_request: {
      status: 401,
      code: 3,
      title: "Unauthorized Request",
      detail: "Unauthorized request, unable to complete request."
    },
    invalid_request_token: {
      status: 401,
      code: 4,
      title: "Invalid Request Token",
      detail: "Invalid request token, unable to complete request. Please hard refresh your browser and try again."
    },
    unprocessable_entity: {
      status: 422,
      code: 5,
      title: "Unprocessable Entity",
      detail: "Unprocessable Entity, unable to complete request."
    }
  }
end
