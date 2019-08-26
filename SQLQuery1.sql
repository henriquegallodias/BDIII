USE master

GO

DROP DATABASE info_loja

GO

CREATE DATABASE info_loja

GO

USE info_loja

GO

create table tb_clientes(
       id_cliente int PRIMARY KEY IDENTITY(1,1),
       nome nvarchar(50) not null,
       endereco nvarchar(100),
       idade int NOT NULL,
       sexo char(1) NOT NULL,
       fone nvarchar(15),
       email nvarchar(70),
)
GO

create table tb_hardware(
       id_hardware int PRIMARY KEY IDENTITY(1,1),
       descricao nvarchar(50) not null,
       preco_unit decimal NOT NULL,
       qtde_atual int NOT NULL, --0 caso nao tenha no estoque
       qtde_minima int,
       img image DEFAULT NULL
)
GO

create table tb_vendas(
       id_venda int primary key IDENTITY(1,1),
       id_cliente int not null,
       data date not null,
       desconto decimal(2,2)
)
GO

CREATE TABLE tb_itens_vendidos(
id_item_vendido INT PRIMARY KEY IDENTITY(1,1),
id_venda INT NOT NULL FOREIGN KEY REFERENCES tb_vendas(id_venda),
id_harware INT NOT NULL FOREIGN KEY REFERENCES tb_hardware(id_hardware),
)
GO

create table tb_vendas_itens(
       id_item int PRIMARY KEY identity(1,1),
       id_venda int not null,
       id_hardware int not null,
       qtde_item int not null,
       pco_vda decimal(8,2) not null
)
GO

CREATE TABLE tb_vendas_canceladas(
id_vendas_canceladas INT PRIMARY KEY IDENTITY(1,1),
id_item_vendido INT NOT NULL FOREIGN KEY REFERENCES tb_itens_vendidos(id_item_vendido)
)

GO