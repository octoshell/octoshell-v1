class Admin::CountriesController < Admin::ApplicationController
  def index
    @countries = Country.order(:title_ru)
  end

  def destroy
    country = Country.find(params[:id])
    country.destroy
    redirect_to admin_countries_path
  end
end

