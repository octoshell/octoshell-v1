class CitiesController < ApplicationController
  respond_to :json

  def index
    country = Country.find(params[:country_id])
    @cities = country.cities.finder(params[:q])
    json = { records: @cities.page(params[:page]).per(params[:per]), total: @cities.count }
    respond_with(json)
  end
  end
end
