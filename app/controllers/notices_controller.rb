class NoticesController < ApplicationController
  def view
    @un = ::User::Notice.where(token: params[:token]).first!
    @un.viewed? || @un.view!
    request.env["HTTP_REFERER"] ||= projects_path
    redirect_to :back, notice: "Вы можете посмотреть прочтенные объявления в своем профиле"
  end
end
