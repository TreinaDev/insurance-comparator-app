class EquipmentsController < ApplicationController

  def index
  end

  def new
    @equipment = Equipment.new
  end
end