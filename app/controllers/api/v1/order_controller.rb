class OrdersController < ActionController::API 

    def insurance_company_approval
        id = params[:id]
        order = Order.find(id)

        order.update!(status: insurance_company_approval)
        params = { policy { client_name: current_client.name, client_registration_number: current_client.cpf,
            client_email: current_client.email, policy_period: order.contract_period, order_id: order.id, package_id: 1,
            insurance_company_id: order.insurance_company_id, equipment_id: equipment.id}}
        response = Faraday.post("http://localhost:4000/api/v1/policies", params)
        if responde.status == 201
            data = JSON.parse(response.body)
            order.update!(policy_id:data['id'], policy_code: data['code'])
        end
    end

    def insurance_approved
        id = params[:id]
        order = Order.find(id)
        status = params.require(:policy).permit(:status)
        if status.active?
            order.update!(status: insurance_approved)
        end
    end
end