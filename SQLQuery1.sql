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

CREATE TABLE tb_clientes_auditoria(
id_cliente int PRIMARY KEY IDENTITY(1,1),
nome VARCHAR(60) NOT NULL,
endereco VARCHAR(120) NOT NULL,
idade INT NOT NULL,
sexo CHAR(1) NOT NULL,
fone VARCHAR(15),
email VARCHAR(70),
acao_de_auditoria VARCHAR(100),
data_da_auditoria DATE
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

CREATE TRIGGER trgAfterInsertCliente ON tb_clientes
FOR INSERT
AS
declare @cliid int;
declare @clinome varchar(60);
declare @cliend varchar(100);
declare @cliida int;
declare @clisex varchar;
declare @clifone varchar(15);
declare @cliemail varchar(70);

declare @audit_action varchar(100);

select @cliid=i.id_cliente from inserted i
select @clinome=i.nome from inserted i
select @cliend=i.endereco from inserted i
select @cliida=i.idade from inserted i
select @clisex=i.sexo from inserted i
select @clifone=i.fone from inserted i
select @cliemail=i.email from inserted i

set @audit_action='Registro Inserido -- [trigger do tipo After Insert na Tb Clientes].';

INSERT INTO tb_clientes_auditoria(nome,endereco,idade,sexo,fone,email,acao_de_auditoria,data_da_auditoria) VALUES (@clinome,@cliend,@cliida,@clisex,@clifone,@cliemail,@audit_action,getdate());

 PRINT 'FIM DE TRIGGER';
GO

INSERT INTO tb_clientes (nome,endereco,idade,sexo,fone,email) VALUES ('Henrique','Rua One',17,'M','11988387640','henrique@gmail.com'),('Maria','Rua 2',18,'F','11999999999','maria@gmail.com'),('Pedro','Rua 3',20,'M','11888888888','pedro@gmail.com'),('Lilian','Rua 3',22,'F','11777777777','lilian@gmail.com');
INSERT INTO tb_clientes (nome,endereco,idade,sexo,fone,email) VALUES ('Maria','Rua 2',18,'F','11999999999','maria@gmail.com'),('Pedro','Rua 3',20,'M','11888888888','pedro@gmail.com'),('Lilian','Rua 3',22,'F','11777777777','lilian@gmail.com');
GO

INSERT INTO tb_produtos (nome,detalhes,data,desconto) VALUES ('Teclado Asus Wi-Fi','Preto','17/01/2002',0.1),('Mouse USB','Dell Branco','20/03/2015',0.2),('Monitor LCD','AOC 24pol','05/05/2016',0.0),('Pen Drive','Kingstom 16gb','25/06/2019',0.4);

GO

INSERT INTO tb_vendas (id_cliente,id_produto,data,desconto) VALUES (1,1,'20/02/2019',0.1),(3,2,'06/02/2018',0.0),(4,4,'01/07/2019',0.4);

GO

INSERT INTO tb_vendas_item (id_venda,id_produto) VALUES (1,1),(3,4),(2,2);

GO

/*SELECT v.id_cliente , c.nome  FROM tb_vendas v
inner join tb_clientes c
on v.id_cliente = c.id_cliente

GO

SELECT v.id_cliente, c.nome FROM tb_clientes c
left join tb_vendas v
on v.id_cliente = c.id_cliente WHERE v.id_cliente IS NULL

GO

/*SELECT v.id_produto,p.id_produto FROM tb_produtos p
left join tb_vendas v
on v.id_produto = p.id_produto WHERE v.id_produto IS NULL

GO */ 

SELECT p.nome,p.id_produto,vi.id_produto FROM tb_produtos p
left join tb_vendas_item vi
on p.id_produto = vi.id_produto WHERE vi.id_produto IS NULL
*/
 GO
 
 SELECT * FROM tb_clientes_auditoria
 
 GO
 
IF OBJECT_ID ('dbo.select_produtos_por_faixa_de_desconto') 
IS NOT NULL 
DROP PROCEDURE dbo.select_produtos_por_faixa_de_desconto 

GO 

IF OBJECT_ID ('dbo.select_produtos_por_faixa_de_desconto') IS NOT NULL 
DROP PROCEDURE dbo.aplica_desconto_no_preco

GO  
          
CREATE PROCEDURE dbo.select_produtos_por_faixa_de_desconto( @desc_min as decimal(10,2), @desc_max as decimal(10,2) ) 
AS BEGIN  
select @desc_min as "Desconto Minimo", @desc_max as "Desconto Maximo" 
END

GO

DECLARE @DescontoMinimo decimal(5,2); DECLARE @MaximoDeDesconto decimal(5,2);
SET  @DescontoMinimo = 10.5; 
SET  @MaximoDeDesconto = 20.5;
Exec dbo.select_produtos_por_faixa_de_desconto @DescontoMinimo,@MaximoDeDesconto Exec dbo.select_produtos_por_faixa_de_desconto @desc_min=@DescontoMinimo,@desc_max=@MaximoDeDesconto

GO
      
CREATE PROCEDURE dbo.aplica_desconto_no_preco( @pco as decimal(10,2), @perc_de_desconto as decimal(10,2) = 0.0, @pco_com_desconto as decimal(10,2) OUTPUT ) 
AS BEGIN  
SELECT @pco_com_desconto = @pco - (@pco * @perc_de_desconto)
SELECT @pco_com_desconto as "Preco Com Desconto" 
END 

GO

DECLARE @Preco decimal(5,2); 
DECLARE @PercentualDeDesconto decimal(5,2); 
DECLARE @PrecoComDesconto decimal(5,2); 
SET  @Preco = 100; 
SET  @PercentualDeDesconto = 0.5;
Exec dbo.aplica_desconto_no_preco @Preco,@PercentualDeDesconto,@PrecoComDesconto output PRINT N'mostrando o resultado da procedure' 
PRINT N'o vlr da variavel de output da procedure foi atribuido a nossa variavel @PrecoComDesconto' 
SELECT @PrecoComDesconto 
AS 
"Vlr da Variavel @PrecoComDesconto"
