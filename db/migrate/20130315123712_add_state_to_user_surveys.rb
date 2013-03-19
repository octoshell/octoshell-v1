class AddStateToUserSurveys < ActiveRecord::Migration
  def change
    add_column :user_surveys, :state, :string
  end
end
