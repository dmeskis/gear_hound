class Api::V1::BaseController < ApplicationController
  include Auth, Error, Permissions
end
