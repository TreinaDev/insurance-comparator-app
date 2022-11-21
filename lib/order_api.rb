class OrderApi

  def initialize(order, equipment, client)
    @id = order.id
    @code = order.code
    @package_name = order.package_name
    @insurance_company_id = order.insurance_company_id
    @insurance_name = order.insurance_name
    @product_category_id = order.product_category_id
    @product_category = order.product_category
    @product_model = order.product_model
    @contract_period = order.contract_period
    @price = order.price
    @voucher = order.voucher
    @final_price = order.final_price
    @status = order.status
		@equipment = EquipmentApi.new(equipment)
		@client = ClientApi.new(client)
  end
end