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

CREATE TABLE tb_vendas_item(
id_vendas_item INT PRIMARY KEY IDENTITY(1,1),
id_venda INT NOT NULL FOREIGN KEY REFERENCES tb_vendas(id_venda),
id_produto INT NOT NULL FOREIGN KEY REFERENCES tb_produtos(id_produto)
)

GO

INSERT INTO tb_clientes (nome,endereco,idade,sexo,fone,email) VALUES ('Henrique','Rua One',17,'M','11988387640','henrique@gmail.com'),('Maria','Rua 2',18,'F','11999999999','maria@gmail.com'),('Pedro','Rua 3',20,'M','11888888888','pedro@gmail.com'),('Lilian','Rua 3',22,'F','11777777777','lilian@gmail.com');

GO

INSERT INTO tb_produtos (nome,detalhes,data,desconto) VALUES ('Teclado Asus Wi-Fi','Preto','17/01/2002',0.1),('Mouse USB','Dell Branco','20/03/2015',0.2),('Monitor LCD','AOC 24pol','05/05/2016',0.0),('Pen Drive','Kingstom 16gb','25/06/2019',0.4);

GO

INSERT INTO tb_vendas (id_cliente,id_produto,data,desconto) VALUES (1,1,'20/02/2019',0.1),(3,2,'06/02/2018',0.0),(4,4,'01/07/2019',0.4);

GO

INSERT INTO tb_vendas_item (id_venda,id_produto) VALUES (1,1),(3,4),(2,2);

GO

SELECT v.id_cliente , c.nome  FROM tb_vendas v
inner join tb_clientes c
on v.id_cliente = c.id_cliente

GO

SELECT v.id_cliente, c.nome FROM tb_clientes c
left join tb_vendas v
on v.id_cliente = c.id_cliente WHERE v.id_cliente IS NULL

GO

SELECT v.id_produto,p.id_produto FROM tb_produtos p
left join tb_vendas v
on v.id_produto = p.id_produto WHERE v.id_produto IS NULL

GO 

SELECT p.id_produto,vi.id_produto FROM tb_produtos p
left join tb_vendas_item vi
on p.id_produto = vi.id_produto WHERE vi.id_produto IS NULL


 