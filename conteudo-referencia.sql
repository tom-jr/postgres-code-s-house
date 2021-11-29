    //  DataType
    Campos do tipo string
 usados para armazenar campos alfa-numericos. Entre os campos do tipo string, temos:

    varying(n): variavel do tipo string, informando o limite como parametro
    varchar(n): tipo de variavel padrao para o tipo string. informa o limite como parametro
    character(n): tipo variavel string
    char(): tipo de string que possui o tamanho fixo, o numero de caracteres deve ser informado no parametro
    text: variavel de tamanho ilimitado. Usamos o campo text para armazenar informações no formato de texto.



    Campos do tipo boolean

 variveis do tipo boolean são utilizados para testar condições como verdadeira(true) ou falso(false) 


    Campos do tipo Numericos

 utilizados para armazenar numeros. Conselho de evitar salvar numeros em variaveis do tipo strings


    smallint:   capacidade 2 bytes numeros -->  -32768 até +32767
    integer:    capacidade 4 bytes --> -2147483648 até +2147483647
    bigInt:     capacidade 8 bytes --> -9223372036854775808 até +9223372036854775807
    decimal:    para numeros de precisao decimal --> 131072 dígitos antes do ponto decimal e 16383 dígitos depois
    numeric:    tambem para numeros de precisao -->131072 dígitos antes da casa decimal e 16383 dígitos depois
    real:       capacidade 4 bytes --> ate 6 digitos decimais
    double:     capacidade 8 bytes --> 15 dígitos nas casas decimais
    smallserial:capacidade 2 bytes --> números inteiros de 1 até 32767
    serial:     capacidade 4 bytes --> Armazena números inteiros de 1 até 2147483647
    bigserial   capacidade 8  bytes --> 1 até 9223372036854775807


    Campo autoincremental

 São campos que possuem a capacidade de aumentar automaticamente. A cada novo registro em uma tabela ele soma +1 no campo 
 correspondente ao dado


   Campos do tipo Data

 Usados para armazenar datas. Não use string para armazenar datas, Tipos:

   timestamp:  capacidade 8 bytes --> Armazena data e hora
   date:       capacidade 4 bytes --> Armazena  Apenas data
   time:       capacidade 8 bytes --> Armazena apenas horas.



   Campo do tipo full text search

 Postgresql possui dois campo para dar suporte a esse tipo de busca Full text search, é aa atividade de buscar atravez 
 de coleções naa propriaa linguagem do SGBD. 
O full text pode ser usado em situações em que umaa grande quantidade de texto precisa ser pesquisado e os resultados
devem obedecer a uma regra linguistica
O Full Text Search possui grandes vantagens em
relação a outras alternativas para pesquisas textuais, como o
comando LIKE

   tsvector: tip de dado que representa um documento, como uma lista ordenada e com posições no texto.
   tsquery: tipo de dados para busca textual, suporta operadores booleans


   Tipo XML

 Postgres tem a capacidade de manipular dados XML


   Tipo JSON

 O suporte a JSON possibilita que o Postgres possa ser usado como um banco Nosql(Banco não relaacional)
  JSON e JSONB json binario, remove os espaços no campo de json, facilitando as buscas.   



   Tipos Arrays

 Postgres permite colunas de uma tabela para ser definidos como matrizes multidimensionais de comprimentos variaveis

   integer[n]:       array do tipo inteiro 
   varchar[n][n]:    array varchar bidimensional
   double array:     array do tipo double de tamanho unidimensional indefinido


   Tipo composto

 Descreve a estrutura de uma linha ou registro 


   Tipo personalizado

 tipos personalizados podem ser criados pelo comando create type. Pode ser composto por varios campos ou pode ser uma
 lista de valores.


      Criando as tabelas
   
   sudo su - postgres         -- muda de usuario do terminal
   psql                       -- acessar o banco de dados
   create database mesas;     --criar o banco de dados

   create table mesas(
      id int not null primary key,
      mesa_codigo varchar(20),
      mesa_situacao varchar(1) default 'A',
      data_criacao timestamp,
      data_atualizacao timestamp
   );


create table funcionarios(
   id    int not null primary key,
   funcionario_codigo varchar(20),
   funcionario_nome varchar(100),
   funcionario_situacao varchar(1) default 'A',
   funcionario_comissao real,
   funcionario_cargo varchar(30),
   data_criacao timestamp,
   data_atualizacao timestamp
);

create table vendas(
   id       int not null primary key,
   funcionario_id integer references funcionarios (id),
   mesa_id integer references mesas (id),
   venda_codigo varchar(20),
   venda_valor    real,
   venda_total    real,
   venda_desconto real,
   venda_situacao varchar default 'A',
   data_criacao   timestamp,
   data_atualizacao timestamp

);


create table produtos(
   id                int not null primary key,
   produto_codigo    varchar(20),
   produto_nome      varchar(60),
   produto_valor     real,
   produto_situacao  varchar(1) default 'A',
   data_criacao      timestamp,
   data_atualizacao  timestamp
);


create table itens_venda(
   id             int not primary key,
   produto_id     int not null integer references produtos (id),
   vendas_id      int not null references vendas (id),
   item_valor     real,
   item_quantidade int,
   item_total     real,
   data_criacao   timestamp,
   data_atualizacao timestamp
);

create table comissoes(
   id                int not null primary key,
   funcionario_id    int references funcionarios (id),
   comissao_valor    real,
   comissao_situacao varchar(1) default 'A',
   data_criacao      timestamp,
   data_atualizacao  timestamp
);


\dt                --lista todas as table





      Constrain
 Servem para definir limeste, comportamentos que restrigem linhas de tabelas. Gerando erro caso essas constrain
 declaradas forem descumpridas durante os processos do SGBD  

 drop table comissoes; -- deleta a table comissoes

 Criar a table sem as constrain

 create table comissoes(
    id                  int not null,
    funcionario_id      int,
    comissao_valor      real,
    comissao_situacao   varchar(1) default 'A',
    data_criacao        timestamp,
    data_atualizacao    timestamp
 );


   criar a constrain PK

   alter table comissoes
   add constraint comissoes_pkey primary key(id);


   alter table comissoes
   add foreign key (funcionario_id)  references funcionarios(id);







Se em algum momento você precisar deletar uma constraint,
algo que não aconselho, utilize o comando:

   alter table comissoes
   drop constraint comissoes_funcionario_id_fkey;
  
   Constraint de validação

 utilizadas para dar mais segurança aos dados atravez de validações

   a ideai deste check é bem evidente pela sintaxe.
 alter table vendas add check(venda_total > 0);

 um check se o nome dos funcionarios é diferente de null
 alter table funcionarios add check(funcionario_nome <> null) 



      Criando sequencias para as tabelas
 
 Criando sequencia para os campos id das tabelas eles teram a função de autoincremento.
 
   create sequence mesa_id_seq;
   create sequence funcionarios_id_seq;



Atribuindo a sequencia a tabela
alter table comissoes 
alter COLUMN id set default nextval('comissoes_id_seq');

para deletar uma sequence
 drop sequence comisssoes_id_seq cascade;

 O cascade é para deletar mesmo que esteja aplicada a uma table



      Alterando tabelas

 Inserir um novo campo na tabela comissoes

   alter table comissoes
   add column data_pagamento int;

   Para excluir uma column o comando é:
   alter table comissoes
   drop column data_pagamento;

 Altrar nome de uma column
   ALTER TABLE table_name 
RENAME COLUMN column_name TO new_column_name;



         Inserir Registros

 insert into mesas 
(mesa_codigo , mesa_situacao, data_criacao,data_atualizacao) values 
('00001','A', '01/01/2016','01/01/2016');




      Consultando os registros.
   Selecionar todos os registros de mesa na tabela mesa.
   
   select mesas.* from mesas;
 Para selecionar campos especificos

   select mesas.campo_nome, mesas.campo_nome from mesas;

   Usamos o where para filtrar a busca em nossa table

   select mesas.* from mesas where mesa_codigo = '00002';   

Alterar valor da table com o comando UPDATE

   UPDATE produtos set produto_valor = 4 where produtos.id = 2;

se não utilizarmos o where todos os campos são modificados da tabela alterada.

   pada deletar uma ou mais rows de uma table

delete from mesas where id = 2;
 


 

