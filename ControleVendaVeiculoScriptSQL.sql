/*
use [master];
go

drop database [BD_CONTROLE_VENDA_VEICULO];
go
*/

create database [BD_CONTROLE_VENDA_VEICULO];
go

use [BD_CONTROLE_VENDA_VEICULO];
go

create table UF (
	id int identity not null,
	numero varchar(30) not null,
	descricao varchar(50) not null
	constraint pk_UF primary key (id),
	constraint uk_numero_UF unique (numero)
);
go

create table cidade (
	id int identity not null,
	numero varchar(30) not null,
	descricao varchar(100) not null,
	id_UF int not null,
	constraint pk_cidade primary key (id),
	constraint uk_numero_cidade unique (numero),
	constraint fk_cidade_UF foreign key (id_UF) references UF(id)
);
go

create table bairro (
	id int identity not null,
	numero varchar(30) not null,
	descricao varchar(100) not null,
	id_cidade int not null,
	constraint pk_bairro primary key (id),
	constraint uk_numero_bairro unique (numero),
	constraint fk_bairro_cidade foreign key (id_cidade) references cidade(id)
);
go

create table logradouro (
	id int identity not null,
	numero varchar(30) not null,
	CEP char(9) not null,
	descricao varchar(100) not null,
	id_bairro int not null,
	constraint pk_logradouro primary key (id),
	constraint uk_numero_logradouro unique (numero),
	constraint uk_CEP_logradouro unique (CEP),
	constraint fk_logradouro_bairro foreign key (id_bairro) references bairro(id)
);
go

create table endereco (
	id int identity not null,
	numero_moradia varchar(10) not null,
	complemento varchar (50) null,
	id_logradouro int not null,
	constraint pk_endereco primary key (id),
	constraint fk_endereco_logradouro foreign key (id_logradouro) references logradouro(id)
);
go

create table loja (
	id int identity not null,
	numero varchar(30) not null,
	nome varchar(100) not null,
	tipo varchar(10) not null default 'MATRIZ',
	id_endereco int not null,
	constraint pk_loja primary key (id),
	constraint uk_numero_loja unique (numero),
	constraint fk_loja_endereco foreign key (id_endereco) references endereco(id),
	constraint ck_tipo_loja check (tipo = 'MATRIZ' or tipo = 'FILIAL')
);
go

create table loja_telefone (
	id int identity not null,
	descricao varchar(20) not null,
	id_loja int not null,
	constraint pk_loja_telefone primary key (id),
	constraint fk_loja_telefone_loja foreign key (id_loja) references loja(id) on delete cascade
);
go

create table loja_email (
	id int identity not null,
	descricao varchar(100) not null,
	id_loja int not null,
	constraint pk_loja_email primary key (id),
	constraint fk_loja_email_loja foreign key (id_loja) references loja(id) on delete cascade
);
go

create table vendedor (
	id int identity not null,
	numero varchar(30) not null,
	nome varchar(100) not null,
	id_loja int not null,
	constraint pk_vendedor primary key (id),
	constraint uk_numero_vendedor unique (numero),
	constraint fk_vendedor_loja foreign key (id_loja) references loja(id)
);
go

create table vendedor_telefone (
	id int identity not null,
	descricao varchar(20) not null,
	id_vendedor int not null,
	constraint pk_vendedor_telefone primary key (id),
	constraint fk_vendedor_telefone_vendedor foreign key (id_vendedor) references vendedor(id) on delete cascade
);
go

create table vendedor_email (
	id int identity not null,
	descricao varchar(100) not null,
	id_vendedor int not null,
	constraint pk_vendedor_email primary key (id),
	constraint fk_vendedor_email_vendedor foreign key (id_vendedor) references vendedor(id) on delete cascade
);
go

create table cliente (
	id int identity not null,
	numero varchar(30) not null,
	CPF char(14) not null,
	nome varchar(100) not null,
	id_endereco int not null,
	constraint pk_cliente primary key (id),
	constraint uk_numero_cliente unique (numero),
	constraint uk_CPF_cliente unique (CPF),
	constraint fk_cliente_endereco foreign key (id_endereco) references endereco(id)
);
go

create table cliente_telefone (
	id int identity not null,
	descricao varchar(20) not null,
	id_cliente int not null,
	constraint pk_cliente_telefone primary key (id),
	constraint fk_cliente_telefone_cliente foreign key (id_cliente) references cliente(id) on delete cascade
);
go

create table cliente_email (
	id int identity not null,
	descricao varchar(100) not null,
	id_cliente int not null,
	constraint pk_cliente_email primary key (id),
	constraint fk_cliente_email_cliente foreign key (id_cliente) references cliente(id) on delete cascade
);
go

create table marca (
	id int identity not null,
	numero varchar(30) not null,
	descricao varchar(50) not null,
	constraint pk_marca primary key (id)
);
go

create table modelo (
	id int identity not null,
	numero varchar(30) not null,
	descricao varchar(50) not null,
	id_marca int not null,
	constraint pk_modelo primary key (id),
	constraint fk_modelo_marca foreign key (id_marca) references marca(id)
);
go

create table veiculo (
	id int identity not null,
	numero varchar(30) not null,
	placa char(8) not null,
	chassi varchar(30) not null,
	ano_fabricacao char(4) not null,
	valor_tabela numeric(10,2) not null,
	id_modelo int not null,
	constraint pk_veiculo primary key (id),
	constraint uk_numero_veiculo unique (numero),
	constraint uk_placa_veiculo unique (placa),
	constraint uk_chassi_veiculo unique (chassi),
	constraint fk_veiculo_modelo foreign key (id_modelo) references modelo(id)
);
go

create table opcional (
	id int identity not null,
	numero varchar(30) not null,
	descricao varchar(100) not null,
	constraint pk_opcional primary key (id)
);
go

create table veiculo_opcional (
	id int identity not null,
	id_veiculo int not null,
	id_opcional int not null
	constraint pk_veiculo_opcional primary key (id),
	constraint fk_veiculo_opcional_veiculo foreign key (id_veiculo) references veiculo(id),
	constraint fk_veiculo_opcional_opcional foreign key (id_opcional) references opcional(id)
);
go

create table venda (
	id int identity not null,
	numero varchar(30) not null,
	desconto numeric(5,2) not null,
	valor_total_pagar numeric(10,2) not null,
	data_venda smalldatetime not null default getdate(),
	id_vendedor int not null,
	id_cliente int not null,
	id_veiculo int not null,
	constraint pk_venda primary key (id),
	constraint uk_numero_venda unique (numero),
	constraint pk_venda_vendedor foreign key (id_vendedor) references vendedor(id),
	constraint pk_venda_cliente foreign key (id_cliente) references cliente(id),
	constraint pk_venda_veiculo foreign key (id_veiculo) references veiculo(id)
);
go

create table forma_pagamento (
	id int identity not null,
	numero varchar(30) not null,
	descricao varchar(50) not null,
	constraint pk_forma_pagamento primary key (id),
	constraint uk_numero_forma_pagamento unique(numero)
);
go

create table item_pagamento (
	id int identity not null,
	numero varchar(30) not null,
	descricao varchar(50) not null,
	constraint pk_item_pagamento primary key(id)
);
go

create table condicao_pagamento (
	id int identity not null,
	numero varchar(30) not null,
	valor numeric(10,2) not null,
	quantidade_parcelas int not null,
	valor_parcela numeric(10,2) not null,
	id_forma_pagamento int not null,
	id_item_pagamento int not null,
	id_venda int not null
	constraint pk_condicao_pagamento primary key (id),
	constraint uk_numero_condicao_pagamento unique (numero),
	constraint fk_condicao_pagamento_forma_pagamento foreign key (id_forma_pagamento) references forma_pagamento(id),
	constraint fk_condicao_pagamento_item_pagamento foreign key (id_item_pagamento) references item_pagamento(id),
	constraint fk_condicao_pagamento_venda foreign key (id_venda) references venda(id)
);
go


-- Inserts UF
insert into UF(numero, descricao) values ('0001', 'MG - Minas Gerais');
insert into UF(numero, descricao) values ('0002', 'RJ - Rio de Janeiro');
insert into UF(numero, descricao) values ('0003', 'SP - São Paulo');
insert into UF(numero, descricao) values ('0004', 'ES - Espírito Santo');
insert into UF(numero, descricao) values ('0005', 'RS - Rio Grande do Sul');
insert into UF(numero, descricao) values ('0006', 'CE - Ceará');
-- select * from UF;

-- Inserts cidade
insert into cidade(numero, descricao, id_UF) values ('0213', 'Belo Horizonte', 1);
insert into cidade(numero, descricao, id_UF) values ('0002', 'Rio de Janeiro', 2);
insert into cidade(numero, descricao, id_UF) values ('0003', 'São Paulo', 3);
insert into cidade(numero, descricao, id_UF) values ('0004', 'Vitória', 4);
insert into cidade(numero, descricao, id_UF) values ('0005', 'Porto Alegre', 5);
insert into cidade(numero, descricao, id_UF) values ('0006', 'Fortaleza', 6);
-- select * from cidade;

-- Insert bairro
insert into bairro(numero, descricao, id_cidade) values ('0001', 'Floresta', 1);
insert into bairro(numero, descricao, id_cidade) values ('0002', 'Copacabana', 2);
insert into bairro(numero, descricao, id_cidade) values ('0003', 'Campo Belo', 3);
insert into bairro(numero, descricao, id_cidade) values ('0004', 'Santa Lúcia', 4);
insert into bairro(numero, descricao, id_cidade) values ('0005', 'Rio Branco', 5);
insert into bairro(numero, descricao, id_cidade) values ('0006', 'José Bonifacio', 6);
-- select * from bairro;

-- Insert logradouro
insert into logradouro(numero, CEP, descricao, id_bairro) values ('0001', '31015-184', 'Rua Pouso Alegre', 1);
insert into logradouro(numero, CEP, descricao, id_bairro) values ('0002', '22031-011', 'Rua Figueiredo de Magalhães', 2);
insert into logradouro(numero, CEP, descricao, id_bairro) values ('0003', '04614-014', 'Rua Vieira de Morais', 3);
insert into logradouro(numero, CEP, descricao, id_bairro) values ('0004', '29056-260', 'Avenida Rio Branco', 4);
insert into logradouro(numero, CEP, descricao, id_bairro) values ('0005', '90420-121', 'Rua Cabral', 5);
insert into logradouro(numero, CEP, descricao, id_bairro) values ('0006', '60040-230', 'Rua Carlos Gomes', 6);
-- select * from logradouro;

-- Insert endereco
insert into endereco(numero_moradia, complemento, id_logradouro) values ('404', null, 1);
insert into endereco(numero_moradia, complemento, id_logradouro) values ('122', 'A', 2);
insert into endereco(numero_moradia, complemento, id_logradouro) values ('1093', null, 3);
insert into endereco(numero_moradia, complemento, id_logradouro) values ('500', null, 4);
insert into endereco(numero_moradia, complemento, id_logradouro) values ('473', null, 5);
insert into endereco(numero_moradia, complemento, id_logradouro) values ('360', null, 6);
-- select * from endereco;

-- Insert loja
insert into loja(numero, nome, tipo, id_endereco) values ('01', 'Loja 1', default, 1);
insert into loja(numero, nome, tipo, id_endereco) values ('02', 'Loja 2', default, 2);
insert into loja(numero, nome, tipo, id_endereco) values ('03', 'Loja 3', default, 3);
insert into loja(numero, nome, tipo, id_endereco) values ('0343', 'Loja 4', 'FILIAL', 4);
insert into loja(numero, nome, tipo, id_endereco) values ('0700', 'Loja 5', 'FILIAL', 5);
insert into loja(numero, nome, tipo, id_endereco) values ('0800', 'Loja 6', 'FILIAL', 6);
-- select * from loja;

-- Insert loja_telefone
insert into loja_telefone(descricao, id_loja) values ('(11)1111-1111', 1);
insert into loja_telefone(descricao, id_loja) values ('(22)2222-2222', 2);
insert into loja_telefone(descricao, id_loja) values ('(33)3333-3333', 3);
insert into loja_telefone(descricao, id_loja) values ('(44)4444-4444', 4);
insert into loja_telefone(descricao, id_loja) values ('(55)5555-5555', 5);
insert into loja_telefone(descricao, id_loja) values ('(66)6666-6666', 6);
-- select * from loja_telefone;

-- Insert loja_email
insert into loja_email(descricao, id_loja) values ('loja1@email.com', 1);
insert into loja_email(descricao, id_loja) values ('loja2@email.com', 2);
insert into loja_email(descricao, id_loja) values ('loja3@email.com', 3);
insert into loja_email(descricao, id_loja) values ('loja4@email.com', 4);
insert into loja_email(descricao, id_loja) values ('loja5@email.com', 5);
insert into loja_email(descricao, id_loja) values ('loja6@email.com', 6);
-- select * from loja_email;

-- Insert vendedor
insert into vendedor(numero, nome, id_loja) values ('11111', 'Emerenciano da Silva', 1);
insert into vendedor(numero, nome, id_loja) values ('22222', 'Vendedor2', 2);
insert into vendedor(numero, nome, id_loja) values ('33333', 'Vendedor3', 3);
insert into vendedor(numero, nome, id_loja) values ('44444', 'Vendedor4', 4);
insert into vendedor(numero, nome, id_loja) values ('55555', 'Vendedor5', 5);
insert into vendedor(numero, nome, id_loja) values ('66666', 'Vendedor6', 6);
-- select * from vendedor;

-- Insert vendedor_telefone
insert into vendedor_telefone(descricao, id_vendedor) values ('(11)1111-1111', 1);
insert into vendedor_telefone(descricao, id_vendedor) values ('(22)2222-2222', 2);
insert into vendedor_telefone(descricao, id_vendedor) values ('(33)3333-3333', 3);
insert into vendedor_telefone(descricao, id_vendedor) values ('(44)4444-4444', 4);
insert into vendedor_telefone(descricao, id_vendedor) values ('(55)5555-5555', 5);
insert into vendedor_telefone(descricao, id_vendedor) values ('(66)6666-6666', 6);
-- select * from vendedor_telefone;

-- Insert vendedor_email
insert into vendedor_email(descricao, id_vendedor) values ('vendedor1@email.com', 1);
insert into vendedor_email(descricao, id_vendedor) values ('vendedor2@email.com', 2);
insert into vendedor_email(descricao, id_vendedor) values ('vendedor3@email.com', 3);
insert into vendedor_email(descricao, id_vendedor) values ('vendedor4@email.com', 4);
insert into vendedor_email(descricao, id_vendedor) values ('vendedor5@email.com', 5);
insert into vendedor_email(descricao, id_vendedor) values ('vendedor6@email.com', 6);
-- select * from vendedor_email;

-- Insert cliente
insert into cliente(numero, CPF, nome, id_endereco) values ('0001', '111.111.111-11', 'Fulano de Tal', 1);
insert into cliente(numero, CPF, nome, id_endereco) values ('0002', '222.222.222-22', 'Cliente2', 2);
insert into cliente(numero, CPF, nome, id_endereco) values ('0003', '333.333.333-33', 'Cliente3', 3);
insert into cliente(numero, CPF, nome, id_endereco) values ('0004', '444.444.444-44', 'Cliente4', 4);
insert into cliente(numero, CPF, nome, id_endereco) values ('0005', '555.555.555-55', 'Cliente5', 5);
insert into cliente(numero, CPF, nome, id_endereco) values ('0006', '666.666.666-66', 'Cliente6', 6);
-- select * from cliente;

-- Insert cliente_telefone
insert into cliente_telefone(descricao, id_cliente) values ('(11)1111-1111', 1);
insert into cliente_telefone(descricao, id_cliente) values ('(22)2222-2222', 2);
insert into cliente_telefone(descricao, id_cliente) values ('(33)3333-3333', 3);
insert into cliente_telefone(descricao, id_cliente) values ('(44)4444-4444', 4);
insert into cliente_telefone(descricao, id_cliente) values ('(55)5555-5555', 5);
insert into cliente_telefone(descricao, id_cliente) values ('(66)6666-6666', 6);
-- select * from cliente_telefone;

-- Insert cliente_email
insert into cliente_email(descricao, id_cliente) values ('cliente1@email.com', 1);
insert into cliente_email(descricao, id_cliente) values ('cliente2@email.com', 2);
insert into cliente_email(descricao, id_cliente) values ('cliente3@email.com', 3);
insert into cliente_email(descricao, id_cliente) values ('cliente4@email.com', 4);
insert into cliente_email(descricao, id_cliente) values ('cliente5@email.com', 5);
insert into cliente_email(descricao, id_cliente) values ('cliente6@email.com', 6);
-- select * from cliente_email;

-- Insert marca
insert into marca(numero, descricao) values ('02', 'FIAT');
insert into marca(numero, descricao) values ('03', 'Marca3');
insert into marca(numero, descricao) values ('04', 'Marca4');
insert into marca(numero, descricao) values ('05', 'Marca5');
insert into marca(numero, descricao) values ('06', 'Marca6');
insert into marca(numero, descricao) values ('07', 'Marca7');
-- select * from marca;

-- Insert modelo
insert into modelo(numero, descricao, id_marca) values ('45', 'Novo Uno', 1);
insert into modelo(numero, descricao, id_marca) values ('03', 'Modelo3', 2);
insert into modelo(numero, descricao, id_marca) values ('04', 'Modelo4', 3);
insert into modelo(numero, descricao, id_marca) values ('05', 'Modelo5', 4);
insert into modelo(numero, descricao, id_marca) values ('06', 'Modelo6', 5);
insert into modelo(numero, descricao, id_marca) values ('07', 'Modelo7', 6);
-- select * from modelo;

-- Insert veiculo
insert into veiculo(numero, placa, chassi, ano_fabricacao, valor_tabela, id_modelo) values ('0001', 'HXX-9999', '9BDXKJDKJDLFKLDJFLDKFJ', '2010', 32510.60, 1);
insert into veiculo(numero, placa, chassi, ano_fabricacao, valor_tabela, id_modelo) values ('0002', 'BBB-2222', '2B2B2B2B2B2B2B2B2B2B2B', '2011', 37900.20, 2);
insert into veiculo(numero, placa, chassi, ano_fabricacao, valor_tabela, id_modelo) values ('0003', 'CCC-3333', '3C3C3C3C3C3C3C3C3C3C3C', '2012', 45800.30, 3);
insert into veiculo(numero, placa, chassi, ano_fabricacao, valor_tabela, id_modelo) values ('0004', 'DDD-4444', '4D4D4D4D4D4D4D4D4D4D4D', '2013', 52900.70, 4);
insert into veiculo(numero, placa, chassi, ano_fabricacao, valor_tabela, id_modelo) values ('0005', 'EEE-5555', '5E5E5E5E5E5E5E5E5E5E5E', '2014', 61550.80, 5);
insert into veiculo(numero, placa, chassi, ano_fabricacao, valor_tabela, id_modelo) values ('0006', 'FFF-6666', '6F6F6F6F6F6F6F6F6F6F6F', '2015', 79320.40, 6);
-- select * from veiculo;

-- Insert opcional
insert into opcional(numero, descricao) values ('01', 'Ar condicionado');
insert into opcional(numero, descricao) values ('05', 'Direção hidráulica');
insert into opcional(numero, descricao) values ('99', 'Predisposição para som');
insert into opcional(numero, descricao) values ('06', 'Opcional6');
insert into opcional(numero, descricao) values ('07', 'Opcional7');
insert into opcional(numero, descricao) values ('08', 'Opcional8');
-- select * from opcional;

-- Insert veiculo_opcional
insert into veiculo_opcional(id_veiculo, id_opcional) values (1, 1);
insert into veiculo_opcional(id_veiculo, id_opcional) values (1, 2);
insert into veiculo_opcional(id_veiculo, id_opcional) values (1, 3);
insert into veiculo_opcional(id_veiculo, id_opcional) values (2, 2);
insert into veiculo_opcional(id_veiculo, id_opcional) values (3, 3);
insert into veiculo_opcional(id_veiculo, id_opcional) values (4, 1);
-- select * from veiculo_opcional;

-- Insert venda
insert into venda(numero, desconto, valor_total_pagar, data_venda, id_vendedor, id_cliente, id_veiculo) values ('01', 8.03, 29900.00, default, 1, 1, 1);
insert into venda(numero, desconto, valor_total_pagar, data_venda, id_vendedor, id_cliente, id_veiculo) values ('02', 8.03, 34860.00, default, 2, 2, 2);
insert into venda(numero, desconto, valor_total_pagar, data_venda, id_vendedor, id_cliente, id_veiculo) values ('03', 8.03, 42130.00, default, 3, 3, 3);
insert into venda(numero, desconto, valor_total_pagar, data_venda, id_vendedor, id_cliente, id_veiculo) values ('04', 8.03, 48600.00, default, 4, 4, 4);
insert into venda(numero, desconto, valor_total_pagar, data_venda, id_vendedor, id_cliente, id_veiculo) values ('05', 8.03, 56600.00, default, 5, 5, 5);
insert into venda(numero, desconto, valor_total_pagar, data_venda, id_vendedor, id_cliente, id_veiculo) values ('06', 8.03, 72950.00, default, 6, 6, 6);
-- select * from venda;

-- Insert forma_pagamento
insert into forma_pagamento(numero, descricao) values ('01', 'CHEQUE');
insert into forma_pagamento(numero, descricao) values ('02', 'DINHEIRO');
insert into forma_pagamento(numero, descricao) values ('03', 'BOLETO');
insert into forma_pagamento(numero, descricao) values ('04', 'FORMA_PAGAMENTO4');
insert into forma_pagamento(numero, descricao) values ('05', 'FORMA_PAGAMENTO5');
insert into forma_pagamento(numero, descricao) values ('06', 'FORMA_PAGAMENTO6');
-- select * from forma_pagamento;

-- Insert item_pagamento
insert into item_pagamento(numero, descricao) values ('01', 'FINANCIAMENTO');
insert into item_pagamento(numero, descricao) values ('02', 'ITEM_PAGAMENTO2');
insert into item_pagamento(numero, descricao) values ('03', 'ENTRADA');
insert into item_pagamento(numero, descricao) values ('04', 'ITEM_PAGAMENTO4');
insert into item_pagamento(numero, descricao) values ('05', 'ITEM_PAGAMENTO5');
insert into item_pagamento(numero, descricao) values ('06', 'ITEM_PAGAMENTO6');
-- select * from item_pagamento;

-- Insert condicao_pagamento
insert into condicao_pagamento(numero, valor, quantidade_parcelas, valor_parcela, id_forma_pagamento, id_item_pagamento, id_venda) values('01', 5000.00, 1, 5000, 2, 3, 1);
insert into condicao_pagamento(numero, valor, quantidade_parcelas, valor_parcela, id_forma_pagamento, id_item_pagamento, id_venda) values('02', 5000.00, 1, 5000, 1, 3, 1);
insert into condicao_pagamento(numero, valor, quantidade_parcelas, valor_parcela, id_forma_pagamento, id_item_pagamento, id_venda) values('03', 19900.00, 60, 464.50, 3, 1, 1);
insert into condicao_pagamento(numero, valor, quantidade_parcelas, valor_parcela, id_forma_pagamento, id_item_pagamento, id_venda) values('04', 48600.00, 1, 48600.00, 2, 3, 4);
insert into condicao_pagamento(numero, valor, quantidade_parcelas, valor_parcela, id_forma_pagamento, id_item_pagamento, id_venda) values('05', 56600.00, 1, 56600.00, 2, 3, 5);
insert into condicao_pagamento(numero, valor, quantidade_parcelas, valor_parcela, id_forma_pagamento, id_item_pagamento, id_venda) values('06', 72950.00, 1, 72950.00, 2, 3, 6);
-- select * from condicao_pagamento;


-- Select CONDIÇÕES DE PAGAMENTO
select cpag.numero 'SEQ', ipag.numero + '-' + ipag.descricao 'ITEM', fpag.numero + '-' + fpag.descricao 'FORMA DE PAGAMENTO', concat('R$ ', cpag.valor) 'VALOR', cpag.quantidade_parcelas 'QTD', concat('R$ ', cpag.valor_parcela) 'VALOR PARCELA', concat('R$ ', (cpag.valor_parcela * cpag.quantidade_parcelas)) 'VALOR FINAL'
from condicao_pagamento as cpag
INNER JOIN forma_pagamento as fpag on cpag.id_forma_pagamento = fpag.id
INNER JOIN item_pagamento as ipag on cpag.id_item_pagamento = ipag.id
where cpag.id_venda = 1;