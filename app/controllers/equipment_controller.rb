class EquipmentController < ApplicationController
  before_action :authenticate_client!
  before_action :set_equipment, only: %i[show edit update edit]

  def index
    @equipment = current_client.equipment
  end

  def show; end

  def new
    @equipment = Equipment.new
  end

  def edit; end

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

  def update
    if @equipment.update(equipment_params)
      redirect_to @equipment, notice: I18n.t('Your equipment has been successfully updated!')
    else
      flash.now[:alert] = I18n.t('It is not possible to edit your equipment.')
      render 'edit'
    end
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  end

  def equipment_params
    params.require(:equipment).permit(:client, :name, :brand, :purchase_date, :invoice, photos: [])
  end
end
