class GroupAbilitiesController < ApplicationController
  def available
    ability = GroupAbility.find(params[:group_ability_id])
    ability.update_attribute(:available, params[:value] == '1')
    redirect_to abilities_path
  end
end
