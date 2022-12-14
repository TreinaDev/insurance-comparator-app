class EquipmentController < ApplicationController
  before_action :authenticate_client!
  before_action :set_equipment, only: %i[show edit update edit]
  before_action :cannot_belong_to_an_order, only: %i[edit update]

  def index
    @equipment = current_client.equipment
  end

  def show; end

  def new
    @equipment = Equipment.new
    @product_categories = Product.all_categories
  end

  def edit
    @product_categories = Product.all_categories
  end

  def create
    @equipment = Equipment.new(equipment_params)
    @equipment.client = current_client
    if @equipment.save
      redirect_to @equipment, notice: t(:equipment_created)
    else
      @product_categories = Product.all_categories
      flash.now[:alert] = t(:equipment_not_created)
      render :new
    end
  end

  def update
    if @equipment.update(equipment_params)
      redirect_to @equipment, notice: t(:equipment_updated)
    else
      @product_categories = Product.all_categories
      flash.now[:alert] = t(:equipment_not_updated)
      render :edit
    end
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  end

  def equipment_params
    params.require(:equipment).permit(:client, :name, :product_category_id, :brand,
                                      :equipment_price, :purchase_date, :invoice, photos: [])
  end

  def cannot_belong_to_an_order
    return if @equipment.orders.blank?

    redirect_to equipment_index_path,
                alert: t(:unable_to_edit_equipment_that_is_linked_to_order)
  end
end
