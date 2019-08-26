USE master

GO

DROP DATABASE info_store

GO

CREATE DATABASE info_store

GO

USE info_store

GO

CREATE TABLE tb_clientes(
id_cliente int PRIMARY KEY IDENTITY(1,1),
nome VARCHAR(60) NOT NULL,
endereco VARCHAR(120) NOT NULL,
idade INT NOT NULL,
sexo CHAR(1) NOT NULL,
fone VARCHAR(15),
email VARCHAR(70)
)
GO

CREATE TABLE tb_produtos(
id_produto INT PRIMARY KEY IDENTITY(1,1),
nome VARCHAR(30) NOT NULL,
detalhes VARCHAR(30) NOT NULL,
data date NOT NULL,
desconto DECIMAL(2,2)
)
GO

CREATE TABLE tb_vendas(
id_venda INT PRIMARY KEY IDENTITY(1,1),
id_cliente INT NOT NULL FOREIGN KEY REFERENCES tb_clientes(id_cliente),
id_produto INT NOT NULL FOREIGN KEY REFERENCES tb_produtos(id_produto),
data date NOT NULL,
desconto DECIMAL(2,2),
)
GO

CREATE TABLE tb_vendas_sucedidas(
id_item_venda_sucedida INT PRIMARY KEY IDENTITY(1,1),
id_venda INT NOT NULL UNIQUE FOREIGN KEY REFERENCES tb_vendas(id_venda),
)
GO

CREATE TABLE tb_vendas_canceladas(
id_venda_cancelada INT PRIMARY KEY IDENTITY(1,1),
id_item_cancelado INT NOT NULL UNIQUE FOREIGN KEY REFERENCES tb_vendas(id_venda)
)
GO

INSERT INTO tb_clientes (nome,endereco,idade,sexo,fone,email) VALUES ('Henrique','Rua One',17,'M','11988387640','henrique@gmail.com');

GO

INSERT INTO tb_produtos (nome,detalhes,data,desconto) VALUES ('Teclado Asus Wi-Fi','Preto','17/01/2002',0.1);