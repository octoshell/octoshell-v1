class CountriesController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        @countries = Country.finder(params[:q])
        render json: { records: @countries.map(&:title_ru).as_json(for: :ajax), total: @countries.count }
      end
    end
  end
end

