class EquipmentApi
  def initialize(equipment)
    @name = equipment.name
    @brand = equipment.brand
    @purchase_date = equipment.purchase_date
  end
end
