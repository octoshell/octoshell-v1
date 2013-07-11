class SuretyMembersController < ApplicationController
  def destroy
    @sm = SuretyMember.find(params[:id])
    (@sm.surety.project.user == current_user) || raise(ActiveRecord::RecordNotFound)
    if @sm.surety.filling?
      @sm.destroy
      @sm.surety.surety_members.any? || @sm.surety.destroy
    end
    redirect_to project_path(@sm.surety.project, anchor: "new-surety")
  end
end
