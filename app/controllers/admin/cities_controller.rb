class Admin::CitiesController < Admin::ApplicationController
  def index
    respond_to do |format|
      format.html do
        country = Country.find(params[:country_id])
        @search = City.search(params[:q])
        search_result = @search.result(distinct: true)
        @cities = show_all? ? search_result : search_result.page(params[:page])
      end

      format.json do
        country = Country.find(params[:country_id])
        @cities = country.cities.finder(params[:q]).order(:title_ru)
        @organizations = Organization.finder(params[:q])
        render json: { records: @cities, total: @cities.count }
      end
    end
  end

  def destroy
    city = City.find(params[:id])
    city.destroy
    redirect_to admin_cities_path
  end
end

