class Api::V1::BaseController < ApplicationController
  # include Auth, Error, 
  include Error, Permissions
end
