module Admin
  class SuretiesController < BaseController
    def index
      @sureties = Surety.order('id desc')
    end
    
    def show
      @surety = find_surety(params[:id])
    end
    
    def find
      @surety = find_surety(params[:id])
      redirect_to [:admin, @surety]
    rescue ActiveRecord::RecordNotFound
      redirect_to [:admin, :sureties], alert: t('flash.alerts.surety_not_found')
    end
    
    def activate
      @surety = find_surety(params[:surety_id])
      if @surety.activate
        redirect_to_surety(@surety)
      else
        redirect_to_surety_with_alert(@surety)
      end
    end
    
    def decline
      @surety = find_surety(params[:surety_id])
      if @surety.decline
        redirect_to_surety(@surety)
      else
        redirect_to_surety_with_alert(@surety)
      end
    end
    
    def cancel
      @surety = find_surety(params[:surety_id])
      if @surety.cancel
        redirect_to_surety(@surety)
      else
        redirect_to_surety_with_alert(@surety)
      end
    end
    
  private
    
    def find_surety(id)
      Surety.find(id)
    end
    
    def redirect_to_surety_with_alert(surety)
      redirect_to [:admin, surety], alert: surety.errors.full_messages.join(', ')
    end
    
    def redirect_to_surety(surety)
      redirect_to [:admin, surety]
    end
  end
end