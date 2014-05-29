class CitiesController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        country = Country.find(params[:country_id])
        @cities = country.cities.finder(params[:q])
        render json: { records: @cities, total: @cities.count }, state: :ok
      end
    end
  end
end
