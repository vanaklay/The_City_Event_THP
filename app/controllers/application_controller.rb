class ApplicationController < ActionController::Base
  include ApplicationHelper
  include UsersHelper
  add_flash_types :info, :warning, :success, :danger
end
