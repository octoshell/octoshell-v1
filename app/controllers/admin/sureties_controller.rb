module Admin
  class SuretiesController < BaseController
    def index
      @sureties = Surety.order('id desc')
    end
  end
end