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
      redirect_to @equipment, notice: t(:equipment_created)
    else
      flash.now[:alert] = t(:equipment_not_created)
      render :new
    end
  end

  def update
    if @equipment.update(equipment_params)
      redirect_to @equipment, notice: t(:equipment_updated)
    else
      flash.now[:alert] = t(:equipment_not_updated)
      render :edit
    end
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  end

  def equipment_params
    params.require(:equipment).permit(:client, :name, :brand, :equipment_price, :purchase_date, :invoice, photos: [])
  end
end
