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
    if @equipment.save
      redirect_to @equipment, notice: 'Seu dispositivo foi cadastro com sucesso!'
    else
      flash.now[:alert] = 'Não foi possível cadastrar seu dispositivo.'
      render 'new'
    end
  end

  private

  def equipment_params
    params.require(:equipment).permit(:name, :brand, :purchase_date, :invoice, photos:[])
  end
end
