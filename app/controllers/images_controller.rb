# coding: utf-8
class ImagesController < ApplicationController
  def index
    @images = Image.all
  end
  
  def new
  end
  
  def create
    if params[:image]
      image = Image.new(params[:image])
      if image.save
        redirect_to images_path
      else
        redirect_to new_image_path, alert: image.errors.full_messages.join(', ')
      end
    else
      redirect_to new_image_path, alert: 'Вы не выбрали файл'
    end
  end
  
  def destroy
    Image.delete(params[:id])
    redirect_to images_path
  end
  
private
  
  def namespace
    :admin
  end
end
