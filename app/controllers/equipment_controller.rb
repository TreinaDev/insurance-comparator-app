class EquipmentController < ApplicationController
  def index; end

  def show
    @equipment = Equipment.find(params[:id])
  end

  def new
    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(equipment_params)
    @equipment.client = current_client
    if @equipment.save
      redirect_to @equipment, notice: I18n.t('Your equipment has been successfully registered!')
    else
      flash.now[:alert] = I18n.t('It is not possible to register your equipment.')
      render 'new'
    end
  end

  private

  def equipment_params
    params.require(:equipment).permit(:client, :name, :brand, :purchase_date, :invoice, photos: [])
  end
end
