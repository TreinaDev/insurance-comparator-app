class PolicyController < ApplicationController
    before_action :authenticate_client!
    before_action :set_equipment, only: [:show, :create]


    def show
        @policy = @equipment.policy
    end

    def create
        params = { body: { client_name: current_client.name, client_registration_number: "99950033340",
            client_email: current_client.email, purchase_date: , policy_period: , order_id: 1, package_id: 1,
            insurance_company_id: 1, equipment_id: equipment.id}}
        response = Faraday.post("http://localhost:4000/api/v1/equipment/#{@equipment.id}/policy", params, "Content-Type" => "application/json" )
        if responde.status == 201
            data = JSON.parse(response.body)
            Policy.create!(data['id'], data['client_name'], data['status'], 
                                    data['order_id'], data['insurance_company_id'], data['code'], 
                                    data['expiration_date'], data['client_registration_number'],
                                data['client_email'], data['equipment_id'], data['purchase_data'], 
                            data['policy_period'], data['package_id'])
        end         
    end

    private

    def set_equipment
        @equipment = Equipment.find(params[:equipment_id])
    end

end
