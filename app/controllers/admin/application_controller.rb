class Admin::ApplicationController < ApplicationController
  before_filter :authorize_admins!

private

  def namespace
    :admin
  end

  def authorize_admins!
    authorize! :access, :admin
  end
end
