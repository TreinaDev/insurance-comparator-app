class EquipmentsController < ApplicationController
  def new 
    @equipment = Equipment.new
  end
end