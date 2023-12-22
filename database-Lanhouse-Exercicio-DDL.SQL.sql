show databases;
/*drop database lanHouseADSManha;
/*drop é pra deletar uma tabela*/
create database lanHouseADSManha;
/*criar uma base de dados*/
use lanHouseADSManha;
/*usar uma base de dados*/

select*from cliente; /*populada*/
select*from empregado; /*populada*/
select*from endereco; /*populada*/
select*from estoque;/*populada*/
select*from fornecedor; /*populada*/
select*from ferias; /*populada*/
select*from formapagamento;	/*base populada*/
select*from servico;/*populada*/
select*from vendas; /*populada*/
select*from estoque_vendas;	/*populada*/
select*from estoque_fornecedor;	/*populada*/
select*from vendas_servico; /*populada*/
select*from servico_fornecedor;	/*populada*/

/*SET SQL_SAFE_UPDATES = 0;*/

/*drop table cliente;
drop table empregado;
drop table estoque;
drop table fornecedor;
drop table servico;
drop table endereco;
drop table ferias;
drop table vendas;
drop table formapagamento;
drop table estoque_fornecedor;
drop table estoque_vendas;
drop table servico_fornecedor;
drop table vendas_servico;*/

/**************************************** Lista de Relatórios ****************************************/ 
 
/* RELATÓRIO 1: Lista dos empregados admitidos entre 2022-01-01 e 2022-03-31, trazendo as colunas 
(Nome Empregado, CPF Empregado, Data Admissão,  Cidade Moradia), ordenado por data de admissão; */
		select emp.nome as "Nome", emp.cpf "E-mail", emp.dataAdmissao "Data Admissao", 
			emp.dataAdmissao "Data Admissão", e.cidade "Cidade"
				from empregado emp, endereco e
					where dataAdmissao between '2022-01-01' and '2022-03-31' and
						e.empregado_cpf = emp.cpf
							order by emp.dataAdmissao;


/* RELATÓRIO 2: Lista dos empregados que ganham menos que média salarial da LanHouse, trazendo as 
colunas (Nome Empregado, CPF Empregado, Salário,  Cidade Moradia), ordenado por nome do empregado; */
		select emp.nome as "Nome", emp.cpf "CPF", emp.salario "Salario", e.cidade "Cidade" 
			from empregado emp, endereco e
				where salario < (select avg(salario) from empregado) and
					e.empregado_cpf = emp.cpf
						order by emp.nome;
            

/* RELATÓRIO 3: Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado, trazendo as colunas 
(Nome Empregado, CPF Empregado, Sexo, Salario, Quantidade Vendas), ordenado por quantidade total de vendas realizadas; */
		select emp.nome "Nome", emp.cpf "CPF", emp.sexo "sexo", count(v.empregado_cpf) "Quantidade Vendas"
			from empregado emp, vendas v
				where v.empregado_cpf = emp.cpf
					group by v.empregado_cpf
						order by count(v.empregado_cpf) desc;
                
                
/* RELATÓRIO 4: Lista das formas de pagamentos mais utilizadas nas Vendas, informando quantas vendas cada forma de pagamento já 
foi relacionada, trazendo as colunas (Tipo Forma Pagamento, Quantidade Vendas), ordenado por quantidade total de vendas realizadas; */
		select fp.tipoPag "Forma de Pagamento", count(fp.vendas_idVendas) "Quantidade Formas de Pag"
			from formapagamento fp, vendas v
				where fp.vendas_idVendas = v.idVendas
					group by fp.tipoPag
						order by count(fp.vendas_idVendas) desc;
 
 
/* RELATÓRIO 5: Lista das Vendas, informando o detalhamento de cada venda quanto os seus itens, trazendo as colunas 
(Data Venda, Nome Produto, Quantidade ItensVenda, Valor Produto, Valor Total Venda, Nome Empregado), ordenado por Data Venda; */
		select ev.dataComp "Data Venda", v.nome "Nome Produto", ev.qtdProduto "Quantidade", es.valor "Valor Produto", 
			v.valor "Valor Total Venda", emp.nome "Nome Empregado"
				from vendas v, estoque es, empregado emp, estoque_vendas ev
					where ev.estoque_idProduto = es.idProduto and 
						ev.vendas_idVendas = v.idVendas and
							v.empregado_cpf = emp.cpf
								order by ev.dataComp asc;
                                
/* RELATÓRIO 6:  Lista das Vendas, informando o detalhamento de cada venda quanto os seus serviços, trazendo as colunas 
(Data Venda, Nome Serviço, Quantidade VendaServico, Valor Serviço, Valor Total Venda, Nome Empregado), ordenado por Data Venda; */
		select fp.dataPag "Data Venda", s.nome "Nome Serviço", vs.quantidade "Quantidade Venda/Servico", 
			s.valor "Valor Serviço", v.valor "Valor Total", e.nome "Nome Empregado"
				from vendas v, servico s, empregado e, vendas_servico vs, formapagamento fp
					where vs.vendas_idVendas = v.idVendas and vs.servico_idServico = s.idServico and v.Empregado_CPF = e.cpf and fp.idFormapag
						order by fp.dataPag asc;
                        		
/* RELATÓRIO 7: Lista dos Produtos, informando qual Fornecedor de cada produto, trazendo as colunas 
(Nome Produto, Valor Produto, Nome Fornecedor, Email Fornecedor, Telefone Fornecedor), ordenado por Nome Produto;  */
		select e.nome "Nome Produto", e.valor "Valor Produto", f.nome "Nome Fornecedor", f.email "E-mail Fornecedor", f.telefone "Telefone Fornecedor" 
			from fornecedor f, estoque e, estoque_fornecedor ef
				where ef.estoque_idProduto = e.idProduto and
					  ef.fornecedor_cnpj = f.cnpj
						order by e.nome asc;   
                        

/* RELATÓRIO 8:Lista dos Serviços, informando qual Fornecedor de cada serviço, trazendo as colunas 
(Nome Serviço, Valor Serviço, Nome Fornecedor, Email Fornecedor, Telefone Fornecedor), ordenado por Nome Serviço;  */
		select s.nome "Nome Servico", s.valor "Valor Servico", f.nome "Nome Fornecedor", f.email "E-mail Fornecedor", f.telefone "Telefone Fornecedor" 
			from fornecedor f, servico s, servico_fornecedor sf
				where sf.servico_idServico = s.idServico and
					  sf.fornecedor_cnpj = f.cnpj
						order by s.nome asc;

                
/* RELATÓRIO 9: Lista dos Produtos mais vendidos, informando a quantidade (total) de vezes que cada produto participou em vendas, 
trazendo as colunas (Nome Produto, Quantidade (Total) Vendas), ordenado por quantidade de vezes que o produto participou em vendas; */
		select e.nome "Nome Produto", count(ev.qtdProduto) "Quantidade (Total) Vendas/Produto"
			from estoque e, estoque_vendas ev, vendas v
				where ev.vendas_idVendas=v.idvendas and ev.estoque_idProduto = e.idProduto
					group by e.nome
						order by count(ev.qtdProduto) desc; 

/* RELATÓRIO 10: Lista dos Serviços mais vendidos, informando a quantidade (total) de vezes que cada serviço participou em vendas, 
trazendo as colunas (Nome Serviço, Quantidade (Total) Vendas), ordenado por quantidade de vezes que o serviço participou em vendas; */
		select s.nome "Nome Produto", count(vs.quantidade) "Quantidade (Total) Vendas/Serviço"
			from servico s, vendas_servico vs, vendas v
				where vs.vendas_idVendas=v.idvendas and vs.servico_idServico = s.idServico
					group by s.nome
						order by count(vs.quantidade) desc; 

/**************************************** FIM DA LISTA de Relatórios ****************************************/ 




create table cliente(
	idCliente int primary key not null auto_increment,
    nome varchar(60) not null,
    email varchar(60) not null unique,
    senha varchar(45),
    sexo char(1) not null,
    dataNasc date not null,
    telefone varchar(11) not null
);

insert into cliente (nome,email,senha,sexo,dataNasc,telefone)
		values  ("Fernando Moreira", "fernandomoreira@gmail.com", "FDMNAF", 'M', '1967-05-02', "81983995959"),
				("Eloá Fernandes", "eloafernandes@gmail.com", "M4TR3P", 'F', '1984-01-17', "81992021330"),
                ("Fabiana Assis", "fabianaassis@gmail.com", "NY6IPA", 'F', '1996-03-26', "81984900498"),
                ("Mariana Silveira", "marianasilveira@gmail.com", "4KXBGQ", 'F', '1942-05-05', "81985063232"),
                ("Paulo Santos", "paulosantos@gmail.com", "IKBD9E", 'M', '1981-04-03', "81982107342"),
                ("Gael Rezende", "gaelrezende@gmail.com", "R1DHPY", 'M', '1970-04-21', "81996225606"),
                ("Nelson Ferreira", "nelsonferreira@gmail.com", "WJMGFA", 'M', '1978-05-04', "81994313389"),
                ("Beatriz Silva", "beatrizsilva@gmail.com", "PRQSQL", 'F', '1964-05-09', "81989828338"),
                ("Isadora Cavalcanti", "isadoracavalcanti@gmail.com", "DKHAEH", 'F', '1945-03-03', "81998881113"),
                ("Bernardo Nascimento", "bernardonascimento@gmail.com", "SXDT1A", 'M', '1973-05-09', "81983452303"),
                ("Raissa Novaes", "raissanovaes@gmail.com", "RDXGCE", 'F', '1986-05-23', "81983278067"),
                ("Alessandra Corte", "alessandracorte@gmail.com", "7GX8LU", 'F', '1992-02-24', "81981152463"),
                ("Rebeca Sales", "rebecasales@gmail.com", "LGYHGF", 'F', '1957-05-13', "81988717269"),
                ("Jéssica Freitas", "jessicafreitas@gmail.com", "MKHKDF", 'F', '1977-04-03', "81994039296"),
                ("Manoela Moura", "manoelamoura@gmail.com", "GALZ92", 'F', '1953-01-10', "81991968006");
                
create table empregado(
	cpf varchar(14) primary key not null,
    nome varchar(60) not null,
    nomeSocial varchar(60),
    sexo char(1) not null,
    salario decimal(6,2) not null,
    email varchar(60) not null unique,
    telefone varchar(11) not null,
    dataNasc date not null,
    dataAdmissao datetime not null,
    dataDemissao datetime,
    statusEmp boolean
);

insert into empregado(cpf,nome,nomeSocial,sexo,salario,email,telefone,dataNasc,dataAdmissao,dataDemissao,StatusEmp)
		values("522.088.784-00", "Adriano Alves", null, 'M', 2658.00, "adrianoalves@gmail.com", "81992796407", '1992-06-02', '2022-03-17 12:30:09', null, 1),
			  ("455.737.914-19", "Alana Barros", null, 'F', 2568.00, "alanabarros@gmail.com", "81999173018", '1993-04-22', '2022-04-22 10:59:40', null, 1),
              ("179.417.004-92", "Bruno Cardoso", null, 'M', 2641.00, "brunocardoso@gmail.com", "81999010011", '1992-04-06', '2022-05-05 12:15:20', null, 1),
              ("195.814.544-03", "Barbara Duarte", null, 'F', 2843.00, "barbaraduarte@gmail.com", "81998516643", '1994-05-06', '2022-05-23 07:51:31', null, 1),
              ("637.142.874-85", "Carlos Fernandes", null, 'M', 2855.00, "carlosfernandes@gmail.com", "81983338010", '1990-01-06', '2022-01-27 13:32:05', null, 1),
              ("821.791.904-68", "Caline Gomes", null, 'F', 2927.00, "calinegomes@gmail.com", "81987562337", '1995-01-11', '2022-04-02 09:04:35', null, 1),
              ("375.428.014-73", "Dalton Lopes", null, 'M', 2951.00, "daltonlopes@gmail.com", "81999173018", '1994-06-05', '2022-05-28 08:28:22', null, 1),
              ("282.450.174-00", "Diana Marques", null, 'F', 3108.00, "dianamarques@gmail.com", "81998307884", '1996-04-02', '2022-03-09 11:29:19', null, 1),
              ("378.144.094-69", "Edgar Nunes", null, 'M', 3191.00, "edgarnunes@gmail.com", "81999178815", '1992-06-05', '2022-02-27 13:53:27', null, 1),
              ("899.185.724-85", "Eduarda Oliveira", null, 'F', 3195.00, "eduardaoliveira@gmail.com", "81999940868", '1990-01-02', '2022-06-16 09:44:58', null, 1);

 create table estoque(
	idProduto int primary key not null auto_increment,
    nome varchar(60) not null,
    valor decimal(6,2) not null,
    quantidade int not null,
    categoria varchar(45) not null,
    descrição varchar(150),
    validade date,
    marca varchar(45)
);

insert into estoque (nome, valor, quantidade, categoria, descrição, validade, marca)
			value	("Cartuchos", 60.00, 100, "Papelaria", "Cartuchos para impressoras colorido e P&B", null, "HP" ),
					("Fone de Ouvido com Fio", 30.00, 60, "Eletrônicos e Periféricos", "Fone de Ouvido com Fio", null, "Logitech"),	
					("Pen Drive 32GB", 40.00, 20, "Eletrônicos e Periféricos", null, null, "Mutilaser"),
                    ("Teclado com Fio", 100.00, 15, "Eletrônicos e Periféricos", null, null, "Mutilaser"),
                    ("Mouse Bluetooth", 50.00, 23, "Eletrônicos e Periféricos", null, null, "Logitech"),
                    ("Caixa de Som", 50.00, 16, "Eletrônicos e Periféricos", null, null, "Multilaser"),
                    ("Webcam com Fio", 30.00, 10, "Eletrônicos e Periféricos", "Resolução de Imagem 8mp", null, "LG"),
                    ("Placas de Vídeo", 700.00, 10, "Eletrônicos e Periféricos", "GeForce GT 740", null, "Nvidia"),
                    ("HD Externo", 200.00, 15, "Eletrônicos e Periféricos", "1TB USB Portátil", null, "Seagate"),
                    ("Fonte Carregador", 20.00, 15, "Eletrônicos e Periféricos", "Fonte Universal para Carregar Smartphones", null, null),
                    ("Trufas", 2.00, 50, "Alimentos", "Trufas (50g) recheadas de diversos sabores", '2022-07-22', "Cia do Cacau" ),
                    ("Donuts", 5.00, 20, "Alimentos", "Rosquinhas Fritas (120g) com cobertura de diversos sabores", '2022-06-27', null),
                    ("Cupcakes", 3.00, 20, "Alimentos", "Bolinho (150g) com cobertura de diversos sabores", '2022-06-27', null),
                    ("Sorvetes", 10.00, 20, "Alimentos", "Sorvete (500g) com diversos sabores", '2022-08-27', "Qbom" ),
                    ("Brownie", 5.00, 15, "Alimentos,", "Brownie (100g) sabor chocolate", '2022-06-27', "DocesFinos" ),
                    ("Sonho", 5.00, 10, "Alimentos", "Pão frito (150g) com cobertura de diversos sabores", '2022-06-27', null),
                    ("Coxinha", 3.00, 15, "Alimentos", "Coxinha recheada (200g) - diversos sabores", '2022-06-22', null),
                    ("Pastel", 3.00, 15, "Alimentos", "Pastel recheado (150g) - diversos sabores", '2022-06-22', null),
                    ("Risoles", 3.00, 15, "Alimentos", "Risoles recheados (200g) - diversos sabores", '2022-06-22', null),
                    ("Esfihas", 5.00, 10, "Alimentos" , "Esfihas (100g) - diversos sabores", '2022-06-22', null),
                    ("Pão de Queijo", 1.00, 50, "Alimentos", "Pão de queijo - unidade (25g)", '2022-06-22', null),
                    ("Empada", 3.00, 15, "Alimentos", "Empada recheada (150g) - diversos sabores", '2022-06-22', null),
                    ("Refrigerante", 4.00, 15, "Alimentos", "Lata 350ml", '2022-12-12', "Coca Cola"),
                    ("Refrigerante", 4.00, 15, "Alimentos", "Lata 350ml", '2022-12-12', "Antártica"),
                    ("Refrigerante", 4.00, 15, "Alimentos", "Lata 350ml", '2022-12-12', "Fanta"),
                    ("Café Expresso", 3.00, 50, "Alimentos", "Xícara 240ml", '2022-12-20', "Mellita"),
                    ("Cappuccino", 6.00, 30, "Alimentos", "Xícara 240ml", '2022-12-20', "Mellita"),
                    ("Suco", 3.00, 50, "Alimentos", "Copo 300ml", '2022-07-20', "DelValle"),
                    ("Café com Leite", 4.00, 30, "Alimentos", "Xícara 240ml", '2022-07-20', "Mellita"),
                    ("Chocolate Quente", 7.50, 20, "Alimentos", "Xícara 240ml", '2022-06-30', Null),
                    ("Chá", 3.00, 50, "Alimentos", "Xícara 240ml", '2022-12-20', "Mate Leão"),
                    ("Água", 3.00, 50, "Alimentos", "Água com gás e sem gás 500ml", '2022-12-20', "Indaiá ");
                    
create table fornecedor(
	cnpj varchar(15) primary key not null,
	nome varchar(60) not null,
	telefone varchar(11) not null,
	email varchar(60) not null unique
);

insert into fornecedor (cnpj, nome, telefone, email)
	values ("797502930001-84", "Cia do Cacau", "8129169005", "ciacacau@gmail.com"),
           ("938075440001-40", "Camara Bebidas LTDA.", "8726653160", "camarabebidaltda@gmail.com"),
           ("572276070001-26", "Pães e Doces do Carmelo","8127425102", "paesedocesdocarmel@gmail.com" ),
           ("391112990001-97", "Padaria Santa Clara","8728165414", "padariasantaclar@gmail.com" ),
           ("025255990001-02", "Wagner Pizzas","8129348332", "wagnerpizza@gmail.com" ),
           ("468671600001-33", "Lanches do Gui","8738470446", "lanchesdogu@gmail.com" ),
           ("617562420001-02", "Padaria Passira","8139618688", "padariapassir@gmail.com" ),
           ("276281080001-80", "Doceria da Nina","8139618688", "doceriadanin@gmail.com" ),
           ("630161460001-45", "Universo Games","8139288181", "universogame@gmail.com" ),
           ("774026670001-45", "LeoCell Eletrônicos","8738359610", "leoceleletronicos@gmail.com" ),
           ("621636530001-49", "Atacarejo Camará","8737487528", "atacarejcamara@gmail.com" ),
           ("393320580001-78", "Mundo dos Eletrônicos","8136681875", "mundoeletronicos@gmail.com" ),
           ("111608360001-70", "LanHouseCamará","8138316194", "lanhousecamara@gmail.com" );


create table servico(
	idServico int primary key not null auto_increment,
	nome varchar(60) not null,
	valor decimal(6,2) not null
);

insert into servico (nome, valor)
	values  ("Distribuidor de Bebidas", 100.00),
			("Distribuidor de Periféricos", 150.00),
            ("Distribuidor de Salgados", 100.00),
            ("Distribuidor de Doces", 100.00),
            ("Distribuidor de Eletrônicos", 150.00),
			("Distribuidor de Itens de Papelaria", 100.00),
            ("Manutenção Computador", 80.00),
            ("Pagamento de conta", 2.00),
			("Recarga Cartuchos", 15.00),
			("Manutenção Impressora", 50.00 ),
			("Manutenção Computador", 80.00),
			("Cópia Documentos", 1.00),
			("Impressão Documentos", 2.00),
			("Gravação de Mídia", 5.00),
			("Digitalização Documentos", 2.00),
			("Digitação Documentos", 5.00);
            

create table endereco(
	idEndereco int primary key not null auto_increment,
    uf varchar(2) not null,
    cidade varchar(45) not null,
    bairro varchar(45) not null,
    rua varchar(45) not null,
    numero int, 
    complemento varchar(45),
    cep varchar(9) not null,
    empregado_cpf varchar(14) not null,
    foreign key(empregado_cpf) references empregado(cpf)
		on update cascade
		on delete cascade
);

insert into endereco (uf, cidade, bairro, rua, numero, complemento, cep, empregado_cpf)
	values  ("PE", "Perolina", "Areia Branca", "Avenida Sete de Setembro", 9, null, "56328-680", "522.088.784-00"),
			("PE", "Recife", "Água Fria", "1° Travessa Iracema Guerra", 51, null, "52211-624", "455.737.914-19"),
            ("PE", "Jaboatão dos Guararapes", "Zumbi do Pacheco", "Rua Santa Maria", 25, null, "54230-115", "179.417.004-92"),
            ("PE", "Garanhuns", "Santo Antônio", "Rua Capitão João Leite", 43, null, "55293-330", "195.814.544-03"),
            ("PE", "Santa Cruz do Capibaribe", "São Cristovão", "Rua Miguel Caloia", 90, null, "55194-000", "637.142.874-85"),
            ("PE", "Gravatá", "Santana", "Alameda dos Cajueiros", 12, null, "55645-801", "821.791.904-68"),
            ("PE", "Vitória de Santo Antão", "Lídia Queiroz", "Rua Nove", 390, null, "55614-755", "375.428.014-73"),
            ("PE", "Olinda", "Águas Compridas", "Rua do Grafite", 555, null, "53160-570", "282.450.174-00"),
            ("PE", "Abreu e Lima", "Desterro", "Rua Rio Angola", 315, null, "53570-090", "378.144.094-69"),
			("PE", "Cabo de Santo Agostinho", "Malaquias", "Rua Sete", 163, null, "54525-150", "899.185.724-85");

create table formapagamento(
	idFormapag int primary key not null auto_increment,
	tipoPag varchar(45) not null,
	valorPag decimal(6,2) not null,
	dataPag datetime not null,
	vendas_idVendas int not null,
    foreign key(vendas_idVendas) references vendas(idVendas)
		on update cascade
		on delete cascade
); 

insert into formapagamento (tipoPag, valorPag, dataPag, vendas_idVendas)
			values  ("Cartão de Crédito", 60.00, '2022-04-23 18:29:00', 1),
					("Cartão de Débito", 50.00, '2022-02-02 22:10:00', 2),
                    ("Dinheiro", 40.00, '2022-01-10 19:45:00', 3),
                    ("Pix", 5.00, '2022-03-13 19:18:00', 4),
                    ("Cartão de Crédito", 50.00, '2022-04-24 11:20:00', 5),
					("Cartão de Débito", 1.00, '2022-01-24 04:53:00', 6),
                    ("Dinheiro", 60.00, '2022-03-04 08:29:00', 7),
                    ("Pix", 1.00, '2022-06-29 15:58:00', 8),
                    ("Cartão de Crédito", 60.00, '2022-06-22 05:16:00', 9),
					("Cartão de Débito", 2.00, '2022-03-11 15:37:00', 10),
                    ("Dinheiro", 60.00, '2022-05-17 19:33:00', 11),
					("Pix", 3.00, '2022-06-01 23:50:00', 12),
					("Cartão de Crédito", 60.00, '2022-01-28 13:30:00', 13),
                    ("Cartão de Débito", 10.00, '2022-06-02 19:57:00', 14),
                    ("Dinheiro", 75.00, '2022-04-07 16:34:00', 15),
					("Pix", 2.00, '2022-04-25 20:54:00', 16),
                    ("Dinheiro", 10.00, '2022-05-09 12:48:00', 17),
                    ("Pix", 3.00, '2022-02-24 13:26:00', 18),
                    ("Cartão de Crédito", 4.00, '2022-05-09 20:09:00', 19);

create table ferias(
	idFerias int primary key not null auto_increment,
    anoReferente year not null,
    qtdDias int not null,
    dataInicio date not null,
    dataFim date not null,
    empregado_cpf varchar(14) not null,
    foreign key(empregado_cpf) references empregado(cpf)
		on update cascade
		on delete cascade
);

insert into ferias (anoReferente, qtdDias, dataInicio, dataFim, empregado_cpf)
		values  ('2021', 30, '2021-03-05', '2021-04-05', "522.088.784-00"),
				('2022', 30, '2022-05-28', '2022-06-28', "455.737.914-19"),
                ('2020', 30, '2020-10-27', '2020-11-27', "179.417.004-92"),
                ('2020', 30, '2020-02-26', '2020-03-26', "195.814.544-03"),
                ('2020', 30, '2020-09-30', '2020-10-30', "637.142.874-85"),
                ('2021', 30, '2021-12-28', '2022-01-28', "821.791.904-68"),
                ('2020', 30, '2020-10-30', '2020-11-30', "375.428.014-73"),
                ('2021', 30, '2021-05-27', '2021-06-27', "282.450.174-00"),
                ('2020', 30, '2020-11-06', '2020-12-06', "378.144.094-69"),
				('2021', 30, '2021-09-07', '2021-10-07', "899.185.724-85");
               
create table vendas(
	idVendas int primary key not null auto_increment,
    nome varchar(60) not null,
    valor decimal(6,2) not null,
    desconto decimal(4,2),
	cliente_idCliente int not null,
    empregado_cpf varchar(14) not null,
    foreign key(cliente_idCliente) references cliente(idCliente),
    foreign key(empregado_cpf) references empregado(cpf)
		on update cascade
		on delete cascade
);

insert into vendas (nome, valor, desconto, cliente_idCliente, empregado_cpf)
	values 	("Cartuchos", 60.00, 0, 1, "179.417.004-92"),
			("Mouse Bluetooth", 50.00, 0, 2, "195.814.544-03"),
			("Pen Drive 32GB", 40.00, 0, 3, "282.450.174-00"),
            ("Donuts", 5.00, 0, 4, "375.428.014-73"),
            ("Caixa de Som", 50.00, 0, 5, "378.144.094-69"),
            ("Pão de Queijo", 1.00, 0, 6, "455.737.914-19"),
            ("Cartuchos", 60.00, 0, 7, "522.088.784-00"),
            ("Cópia Documentos", 1.00, 0, 8, "637.142.874-85"),
            ("Cartuchos", 60.00, 0, 9, "821.791.904-68"),
            ("Pagamento de conta", 2.00, 0, 10, "899.185.724-85"),
            ("Cartuchos", 60.00, 0, 11, "179.417.004-92"),
            ("Água", 3.00, 0, 12, "195.814.544-03"),
            ("Cartuchos", 60.00, 0, 13, "282.450.174-00"),
            ("Sorvetes", 10.00, 0, 14, "375.428.014-73"),
            ("Sonho", 5.00, 0, 15, "378.144.094-69"),
            ("Digitalização Documentos", 2.00, 0, 1, "455.737.914-19"),
            ("Sorvetes", 10.00, 0, 2, "522.088.784-00"),
            ("Café Expresso", 3.00, 0, 3, "637.142.874-85"),
            ("Café com Leite", 4.00, 0, 4, "821.791.904-68"),
            ("Manutenção Computador", 80.00, 0, 5, "378.144.094-69"),
            ("Pagamento de conta", 2.00, 0, 6, "282.450.174-00"),
			("Recarga Cartuchos", 15.00, 0, 7, "195.814.544-03"),
			("Manutenção Impressora", 50.00, 0, 8, "522.088.784-00"),
			("Manutenção Computador", 80.00, 0, 9, "455.737.914-19"),
			("Cópia Documentos", 1.00, 0, 10, "375.428.014-73"),
			("Impressão Documentos", 2.00, 0, 11,"378.144.094-69"),
			("Gravação de Mídia", 5.00, 0, 12, "821.791.904-68"),
			("Digitalização Documentos", 2.00, 0, 13, "637.142.874-85"),
			("Digitação Documentos", 5.00, 0, 14, "179.417.004-92");
            
		

create table estoque_vendas(
	estoque_idProduto int not null,
    vendas_idVendas int not null,
    dataComp datetime not null, 
    qtdProduto decimal(7,2) not null,
    primary key (estoque_idProduto, vendas_idVendas),
	foreign key(estoque_idProduto) references estoque(idProduto),
    foreign key(vendas_idVendas) references vendas(idVendas)
		on update cascade
		on delete cascade
    );

insert into estoque_vendas (estoque_idProduto, vendas_idVendas, dataComp, qtdProduto)
	values 		(1, 1, '2022-04-23 18:29:00', 1),
				(5, 2, '2022-02-02 22:10:00', 1),
				(3, 3, '2022-01-10 19:45:00', 1),
				(12, 4, '2022-03-13 19:18:00', 1),
				(6, 5, '2022-04-24 11:20:00', 1),
				(21, 6, '2022-01-24 04:53:00', 1),
				(1, 7, '2022-03-04 08:29:00', 1),
				(1, 9, '2022-06-22 05:16:00', 1),
				(1, 11, '2022-05-17 19:33:00', 1),
				(32, 12, '2022-06-01 23:50:00', 1),
				(1, 13, '2022-01-28 13:30:00', 1),
				(14, 14, '2022-06-02 19:57:00', 1),
				(16, 15, '2022-04-07 16:34:00', 1),
				(14, 17, '2022-05-09 12:48:00', 1),
				(26, 18, '2022-02-24 13:26:00', 1),
				(29, 19, '2022-05-09 20:09:00', 1);
  

create table estoque_fornecedor(
	estoque_idProduto int not null,
    fornecedor_cnpj varchar(15) not null,
    primary key (estoque_idProduto, fornecedor_cnpj),
	foreign key(estoque_idProduto) references estoque(idProduto),
    foreign key(fornecedor_cnpj) references fornecedor(cnpj)
		on update cascade
		on delete cascade
    );

insert into estoque_fornecedor (estoque_idProduto, fornecedor_cnpj)
		values 	("1", "630161460001-45"),
				("2", "393320580001-78"),
                ("3", "774026670001-45"),
                ("4", "630161460001-45"),
                ("5", "393320580001-78"),
                ("6", "774026670001-45"),
                ("7", "393320580001-78"),
                ("8", "774026670001-45"),
                ("9", "630161460001-45"),
                ("10", "393320580001-78"),
                ("11", "797502930001-84"),
                ("12", "572276070001-26"),
                ("13", "276281080001-80"),
                ("14", "621636530001-49"),
                ("15", "276281080001-80"),
                ("16", "572276070001-26"),
                ("17", "572276070001-26"),
                ("18", "468671600001-33"),
                ("19", "572276070001-26"),
                ("20", "025255990001-02"),
                ("21", "617562420001-02"),
                ("22", "468671600001-33"),
                ("23", "938075440001-40"),
                ("26", "621636530001-49"),
                ("27", "621636530001-49"),
                ("28", "938075440001-40"),
                ("29", "621636530001-49"),
                ("30", "797502930001-84"),
                ("31", "621636530001-49"),
                ("32", "938075440001-40");
				
   
create table servico_fornecedor(
	servico_idServico int not null,
    fornecedor_cnpj varchar(15) not null,
    primary key (servico_idServico, fornecedor_cnpj),
	foreign key(servico_idServico) references servico(idServico),
    foreign key(fornecedor_cnpj) references fornecedor(cnpj)
		on update cascade
		on delete cascade
    );
    
insert into servico_fornecedor (servico_idServico, fornecedor_cnpj)
	values  (1, "938075440001-40"),
            (1, "621636530001-49"),
			(2, "393320580001-78"),
            (2, "774026670001-45"),
			(2, "630161460001-45"),
            (3, "025255990001-02"),
            (3, "391112990001-97"),
            (3, "468671600001-33"),
            (3, "572276070001-26"),
            (3, "617562420001-02"),
            (4, "276281080001-80"),
            (4, "468671600001-33"),
            (4, "572276070001-26"),
            (4, "797502930001-84"),
            (5, "393320580001-78"),
            (5, "630161460001-45"),
            (5, "774026670001-45"),
            (6, "774026670001-45"),
            (7, "111608360001-70"),
            (8, "111608360001-70"),
            (9, "111608360001-70"),
            (10, "111608360001-70"),
            (11, "111608360001-70"),
            (12, "111608360001-70"),
            (13, "111608360001-70"),
            (14, "111608360001-70"),
            (15, "111608360001-70"),
            (16, "111608360001-70");
            
            
create table vendas_servico(
	vendas_idVendas int not null,
    servico_idServico int not null,
    quantidade int not null,
    primary key (vendas_idVendas, servico_idServico),
	foreign key(vendas_idVendas) references vendas(idVendas),
    foreign key(servico_idServico) references servico(idServico)
		on update cascade
		on delete cascade
    );

insert into vendas_servico (vendas_idVendas, servico_idServico, quantidade)
	values	 (20, 11, 1),
			 (21, 8, 1),
             (22, 9, 1),
			 (23, 10, 1),
             (24, 11, 1),
			 (25, 12, 1),
             (26, 13, 1),
			 (27, 14, 1),
             (28, 15, 1),
			 (29, 16, 1);
 
 

                        
                 
                        
							











                        
                        






                
                


         

             
			



