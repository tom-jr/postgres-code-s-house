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



      Functions para poupar esforços


 são um conjunto de procedimentos escritos em SQL que são armazenados no banco de dados afim de executar 
uma determinada função. Auxiliam na proddutividade do administrador do Banco de dados.
   Exemplo de uma function que recebe como parametro um id de funcionario e depos realiza uma consulta de 
   funcionario, retornando assim a concatenação de nome com situacao 


   create or replace function 
   retorna_nome_funcionario(func_id int)
   returns text as
   $$ 
   declare
   nome text;
   situacao text;

   begin
   select funcionario_nome, funcionario_situacao 
    into nome, situacao
   from funcionarios
   where id = func_id;
      if situacao = 'A' then
      return nome || ' Usuario Ativo';
      else
      return nome || ' Usuario Inativo';
      end if;
   end
 $$
   language plpgsql;

      $$ -> usados paara limitar o corpo da função, assim o postgres entende que tudo que esta dentro do 
      $$ $$   é parte do body função criada.

      entre cada $ voce pode inserir uam string. $inicio$  $fim$

      Declare -> Utilizado para informa as declarações de variaveis que receberam valores
                 dos resultados das querys. O campo se encerra assim que o begin é iniciado

      language plpgsql -> é a declarações da linguagem que escrevemos a função. a linguagem padrao do Postgresql

      if e else -> usada para fluxo de desvio dependendo dos resultados das querys realizadas durante a execução da function
                   if var 'valorConddição' then
                   return || 'Um resultado';
                   else
                   return || 'outro resultado';



create or replace function 
   retorna_nome_funcionario(func_id int)
   returns text as
   $$ 
   declare
   nome text;
   situacao text;

   begin
   select funcionario_nome, funcionario_situacao 
    into nome, situacao
   from funcionarios
   where id = func_id;
      if situacao = 'A' then
      return nome || ' Usuario Ativo';
      elsif situacao = 'I' then
      return nome || ' Usuario Inativo';
      elsif situacao is null then
      return nome || ' Usuário Sem status';
      else
      return 'Usuário com status diferente de A e I';
      end if;
   end
 $$
   language plpgsql;



   create or replace function rt_valor_commissao(func_id int)
   return real as
   $$
   declare
   valor_comisao real;
   begin
   select funcionario_comissao into valor_comisao from funcionarios
   where id = func_id;

   return funcionario_comissao;
   end
   $$
   language plpgsql;


create or replace function 
calc_comissao(data_timestamp_init,data_time_stamp_fim)
returns void as
$$
total_comissao real := 0;
porc_comissao  real := 0;

reg record;
cr_porce CURSOR (func_id int) IS
select rt_valor_comissao(func_id);
begin

for reg in(
select vendas.id id,
funcionario_id,
venda_total
from vendas
where data_criacao >= data_ini
and data_criacao <= data_fim
and venda_situacao = 'A')loop

open cr_porce(reg.funcionario_id);
fetch cr_porce into porc_comissao;
close cr_porce;
total_comissao := (reg.venda_total *
porc_comissao)/100;
insert into comissoes(
funcionario_id,comissao_valor,
comissao_situacao,
data_criacao,
data_atualizacao)
values(reg.funcionario_id,
total_comissao,
'A',
now(),
now());
update vendas set venda_situacao = 'C'
where id = reg.id;
total_comissao := 0;
porc_comissao := 0;
end loop;
end
$$
language plpgsql;





Operadores Logicos

AND
Descrição
Utilizamos quando queremos incluir duas ou mais condições em nossa
operação. Os registros recuperados em uma declaração que une duas
71condições com este operador deverão suprir as duas ou mais condições

OR
 Utilizamos quando queremos combinar duas ou mais condições em nossa
operação. Os registros recuperados em uma declaração que une duas
condições com este operador deverão suprir uma das duas condições
NOT
 Utilizamos quando não queremos que uma das condições seja cumprida. Os
registros recuperados em uma declaração que exclui uma condição não

insert into produtos (produto_codigo,
produto_nome,
produto_valor,
produto_situacao,
data_criacao,
data_atualizacao)
values ('2832',
'SUCO DE LIMÃO',
15,
'C',
'02/02/2016',
'02/02/2016');

select * from produtos where produto_situacao = 'A' and produto_situacao = 'C';

select * from produtos where produto_situacao = 'A' or produto_situacao = 'C';

select * from produtos where produto_situacao = 'A' and produto_situacao = 'C';

select * from produtos where produto_situacao = 'A';

select * from produtos where produto_situacao = 'A' or produto_situacao ='C' and data_criacao = '02/02/2016';




            Operadores de comparação


<        Menor
>        Maior
<=       Menor Igual
>=       Maior Igual
=        Igual 


select vendas.funcionario_id from vendas 
   where vendas.data_criacao >= 'data_init' and < 'data_fin' and vendas.venda_situacao = 'A';


select vendas.funcionario_id, vendas.venda_total from vendas 
where vendas.data_criacao >= '01/01/2016'
and
      vendas.data_criacao < '02/02/2016'
and   vendas.venda_situacao = 'A';





         Operadores e funções matematicas


+     adição            2 + 2 = 5
-     subtração         2 - 3 = 1
*     multiplicação     2 * 3 = 6
/     divisão           4 / 2 = 2
%     modulo            5 % 4 = 1
^     exponencial       2.0 ^ 3.0 = 8 
!     Fatorial          5!    = 120
!!    fatorial          !!5   = 120
@     valor abs         @ -5.2 = 5


         Funções de texto

   Concatenar string 

select funcionarios.funcionario_codigo || funcionarios.funcionario_nome 
from funcionarios 
   where funcionarios.id = 1;

   restaurante=# select funcionarios.funcionario_codigo ||' -- '|| funcionarios.funcionario_nome 
from funcionarios 
   where funcionarios.id = 1;


 Comando para contar o numero de caracteres de um campo

 select char_length(funcionarios.funcionario_nome) from funcionarios where funcionarios.id = 1


      Da um upper case nos strings
   select upper(funcionarios.funcionario_nome) from funcionarios;

   inciar as Palavras em upperCase.
   select initCap('antonio carlos');

 
  Lower Case.
  select lower('ANTONIO');


   realizar replace, sunstituição ecaracters de acordo com o parametro e os campos da string

   select overlay(funcionarios.funcionario_nome placing '******' from 3 for 5) from funcionarios where funcionarios.id =1;


 Pesquisar a posição de determinada string em um registro

 select position('ius' in funcionarios.funcionario_nome) from funcionarios where funcionarios.id = 1;



         Funções Datas e Horas


   Formato de datas no Brasil  dia/mes/ano 
 A maiori dos SGBD usam por padrao Mes/dia/ano ou Ano/mes/dia 

 Para descubrir o formato que esta o nosso banco de dados utilizzamos o comando
 show datestyle;

 Para mudar para o datastyle que desejamas utilizamos o comando
 alter database restaurante set datestyle to iso, dmy;

 função do Postgres para verificar idade;
  age(timestamp 'd/m/y');
  retorna a idade correta


No livro fica exemplo varias funções de data/hora.



      Funções Agregadoras

 Comando para realizar contagens de registro de tabelas

   select count(uncionarios.id) from funcionarios; -- contara os funcionarios utilizando o id como base

 
 select sum(vendas.venda_total) from vendas; --soma os valores de um todos os campos especificado na tabela


            Calculando media dos valores com avg();

   select avg(produtos.produto_valor) from produtos;

   Valore maximo e minimo

select max(produtos.produto_valor), min(produtos.produto_valor) from produtos;



Agrupando regstro com o  Group by

O group by auxilia em uma busca onde se deseja buscar elemonstos que reicidem na tabela


select produto_id , sum(iten_total) from itens_vendas group by produto_id;
--seleciona os id_produto de itens vendaas, agrupados por produtos_id  ira retorna apenas os que tem reincidencia



