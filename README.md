# Banco de Dados para Oficina
Este projeto implementa um banco de dados relacional para o gerenciamento de uma oficina mecânica. O objetivo é estruturar e armazenar informações sobre clientes, veículos, funcionários, serviços, ordens de serviço e pagamentos. O sistema foi projetado para ser robusto e permitir consultas complexas, possibilitando uma visão detalhada das operações da oficina.

## Estrutura do Banco de Dados
O banco de dados segue o esquema lógico baseado no modelo relacional e inclui as seguintes tabelas principais:

- Clientes: Armazena informações pessoais dos clientes (nome, CPF/CNPJ, telefone, e-mail).
- Veículos: Detalhes dos veículos dos clientes, incluindo placa, modelo, marca e ano.
- Funcionários: Informações sobre os funcionários da oficina, como cargo e salário.
- Serviços: Catálogo de serviços disponíveis, com preço e duração estimada.
Ordem de Serviço: Registro de solicitações de manutenção ou reparo, com status e valor total.
- Ordem de Serviço - Serviços: Relaciona serviços realizados às ordens de serviço.
Pagamentos: Histórico de pagamentos efetuados para ordens de serviço.
