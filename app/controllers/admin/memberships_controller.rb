class Admin::MembershipsController < Admin::ApplicationController

  def index
    search_result = Membership.search(params[:q]).result(distinct: true)
    @memberships = show_all? ? search_result : search_result.page(params[:page])
  end
end
