# insurance-comparator-app
Projeto de app que compara e permite compra de pacotes de seguros (Campus Code - TreinaDev Delas).


## Configurações necessárias
- Ruby 3.1.2 
- Rails 7.0.4 
- NodeJS 18.12.0
- Yarn 1.22.19 

### Gems instaladas
- Rspec-rails (testes)
- Devise (criação e autenticação de usuários)
- Capybara (testes - ações do usuário)
- Faraday (requisições HTTP)
- Rubocop (análise de condigo - boas praticas)
- Rubocop (análise de condigo - boas praticas)
- Bootstrap (front-end da app)
- Simplecov (análise da cobertura de testes)
- Factorybot (população de banco de dados)


## Setup da app
Antes de utilizar, é necessário clonar e instalar as dependencias:
bin/setup

Popule a app com os dados do banco:
rails db:seed

Visualize a app no browser:
rails bin/dev - localhost:3000

Execute os testes:
rspec

### Dados adicionais
Login de cliente para acesso da app:
Email: ana@gmail.com
Senha: 12345678


## Associações com APIs externas
Os dados a serem fornecidos para os usuários desta app serão consumidos via APIs criadas pelas aplicações Sistema de Seguradoras Sistema de Pagamento e Antifraude.

### Insurance-app
- Resultado da busca por pacotes de seguro (pacotes das seguradoras que atendem ao produto indicado pelo cliente);
- Apólice do cliente (com dados da aquisição + data de vencimento);

### payment-antifraud
- Formas de pagamento disponíveis (de acordo com a seguradora do pacote);
- Validação de cupom de desconto;
- Validação de CPF (anti-fraude);

