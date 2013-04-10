class AccountCodesController < ApplicationController
  def destroy
    @project = current_user.owned_projects.find(params[:project_id])
    ids = SuretyMember.where(surety_id: @project.surety_ids).pluck(:account_code_id)
    ac = AccountCode.where(id: ids).find(params[:id])
    ac.destroy
    redirect_to @project
  end
end
