# insurance-comparator-app
App que permite a comparação e compra de pacotes de seguros para dispositivos. <br>
Projeto final Campus Code - TreinaDev9 (Delas) 


## ⚙ Configurações necessárias
- [Ruby](https://www.ruby-lang.org/en/documentation/installation/) 3.1.2 
- [Rails](https://guides.rubyonrails.org/getting_started.html) 7.0.4 
- [NodeJS](https://nodejs.org/en/) 18.12.0
- [Yarn](https://classic.yarnpkg.com/lang/en/docs/install/#windows-stable) 1.22.19 
<br>

### 💎 Gems instaladas
- [Rspec-rails](https://rspec.info/documentation/) (Testes)
- [Capybara](https://github.com/teamcapybara/capybara) (Testes - ações do usuário)
- [Devise](https://github.com/heartcombo/devise) (Criação e gerenciamento de autenticação de usuários)
- [Faraday](https://lostisland.github.io/faraday/) (Realizar requisições HTTP)
- [Rubocop](https://docs.rubocop.org/rubocop/installation.html) (Análise de código para garatir boas práticas)
- [Bootstrap](https://getbootstrap.com/docs/3.4/getting-started/) (Front-end da app)
- [Simplecov](https://github.com/simplecov-ruby/simplecov) (Análise da cobertura de testes)
- [Factorybot](https://github.com/thoughtbot/factory_bot/tree/master) (População de banco de dados)
<br>

## 🚀 Como rodar a aplicação
No seu terminal, clone o projeto:
```sh
git@github.com:TreinaDev/insurance-comparator-app.git
```

Instale as dependencias:
```sh
bin/setup
```

Popule a app com os dados do banco:
```sh
rails db:seed
```

Visualize a app no browser:
```sh
rails bin/dev
```
e acesse http://localhost:3000/
<br>

Execute os testes:
```sh
rspec
```
<br>

## API para mudar status de pedido

#### Endpoints:
  - **POST /api/v1/orders/order_id/payment_approved** Para pagamentos confirmados
  - **POST /api/v1/orders/order_id/payment_refused** Para pagamentos recusados

Substitua `order_id` pelo `id` correspondente do pedido. 

Respostas possíveis:
 - 200 (Success)

```json
  { "message": "success" }
```

 - 404 (Not Found)

```json
  { "error": "Invalid ID" }
```

 - 500 (Internal Server Error)

```json
  { "error": "Internal server error" }
```


### ❕ Dados adicionais
Login de cliente para acesso da app:
- Email: ana@gmail.com
- Senha: 12345678


## 🗃 Associações com APIs externas
Os dados a serem fornecidos para os usuários desta app serão consumidos via APIs criadas pelas aplicações [Sistema de Seguradoras](https://github.com/TreinaDev/insurance-app) e [Sistema de Pagamento e Antifraude](https://github.com/TreinaDev/payment-antifraud).

### Insurance-app
- [ ] Resultado da busca por pacotes de seguro (pacotes das seguradoras que atendem ao produto indicado pelo cliente);
- [ ] Apólice do cliente (com dados da aquisição + data de vencimento);

### payment-antifraud
- [ ] Formas de pagamento disponíveis (de acordo com a seguradora do pacote);
- [ ] Validação de cupom de desconto;
- [ ] Validação de CPF (anti-fraude);
<br>

## 👩‍💻 Devs contribuindo no Projeto
- [Aline Moraes](https://github.com/alisboam)
- [Anyelly Luvizott](https://github.com/anyluvizott)
- [Izabelly Brito](https://github.com/Izabellyrb)
- [Karina Sakata](https://github.com/KarinaMSakata)
- [Luciana Donadio](https://github.com/lcallefe)
- [Sade Oli](https://github.com/sadeoli)
- [Thalis Freitas](https://github.com/Thalis-Freitas)


<h4 align="center">
:construction: Em processo...
</h4>


## Documentação da API

### Obter Pedido

**Endpoint: GET /api/v1/orders/1**

<p align = "justify">Retornos:</p>

`200` (Sucesso)

```json

{
    "id": 1,
    "status": "insurance_company_approval",
    "payment_method": null,
    "contract_period": 10,
    "price": "200.0",
    "coverage": null,
    "insurance_company_id": 45,
    "insurance_name": "Seguradora 45",
    "package_name": "Premium",
    "product_model": "Macbook",
    "final_price": "2000.0",
    "voucher_price": "10.0",
    "code": "0HOIFGR9NNUGRM0",
    "max_period": 24,
    "min_period": 1,
    "product_category": "Computadpr",
    "voucher_code": "DESCONTO10",
    "product_category_id": 1,
    "equipment": {
    "name": "Macbook Air",
    "brand": "Apple",
    "purchase_date": "2021-04-13",
    "equipment_price": "15129.0"
    },
    "client": {
    "email": "ana@gmail.com",
    "name": "Ana Lima",
    "cpf": "21234567890",
    "address": "Rua Dr Nogueira Martins, 680",
    "city": "São Paulo",
    "birth_date": "1997-10-29",
    "state": "SP"
    }
}
```
### Obter Pagamento

**Endpoint: GET /api/v1/payments/:order_id**

<p align = "justify">Retornos:</p>

`200` (Sucesso)

```json

{
    "client": {"cpf": "21234567890"},
    "id": 1,
    "invoice_token": "USAIUE55D85A",
    "order": {"insurance_company_id": 45},
    "order_id": 1,
    "parcels": 1,
    "payment_description": "Cartão de Crédito - Laranja",
    "payment_method_id": 1,
    "status": "pending"
}

```

`404` (Não encontrado)

`500` (Erro interno do servidor)`

### Aprovação do Pagamento

**Endpoint: POST /api/v1/payments/:order_id/approved**

**Parametros que devem ser enviados para aprovação do pagamento**

```json

{ "payment": { "status": "approved", "invoice_token": "USAIUE55D85A" }}

```

<p align = "justify">Retornos:</p>

`200` (Sucesso)

```json

{
    "client": {"cpf": "21234567890"},
    "id": 1, 
    "invoice_token": "USAIUE55D85A",
    "order": {"insurance_company_id": 45},
    "order_id": 1,
    "parcels": 1,
    "payment_description": "Cartão de Crédito - Laranja",
    "payment_method_id": 1,
    "status": "approved"
}

```

`412` (Dados inválidos)

```json

{"errors": ["Número da Nota Fiscal não pode ficar em branco"]}

```

### Reprovação do Pagamento

**Endpoint: POST /api/v1/payments/:order_id/refused**

**Parametro que deve ser enviado para reprovação do pagamento**

```json

{ "payment": { "status": "refused" } }

```

<p align = "justify">Retornos:</p>

`200` (Sucesso)

```json

{
    "client": {"cpf": "21234567890"},
    "id": 1, 
    "invoice_token": "USAIUE55D85A",
    "order": {"insurance_company_id": 45},
    "order_id": 1,
    "parcels": 1,
    "payment_description": "Cartão de Crédito - Laranja",
    "payment_method_id": 1,
    "status": "refused"
}

```