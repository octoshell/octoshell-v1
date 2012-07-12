class Admin::SuretiesController < ApplicationController
  def index
    @sureties = Surety.order('id desc')
  end
end