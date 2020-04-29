create database BancoInterface;
Use BancoInterface;

create table Aluno(
id_Matricula int not null,
matricula int,
nome varchar(50),
Email varchar(50),
telefone varchar(12),
sexo char,
data_Nascimento date,
Constraint PK_Id_Matricula PRIMARY KEY (Id_matricula));

Create Table Professor(
id_Professor int not null,
NomeProf varchar(40),
MateriaPrincipal varchar(40),

Constraint PK_Id_Professor Primary Key (Id_Professor));

create table sala(
id_sala int not null,
constraint PK_Id_sala primary key (id_sala));

Create Table Instituicao(
id_Matricula int not null,
Id_Professor int not null,
id_sala int not null, 
constraint FK_id_sala foreign key(id_sala) references sala(id_sala), 
Constraint FK_Id_Matricula Foreign Key (Id_Matricula)
	References Aluno(Id_Matricula),
Constraint FK_Id_Professor Foreign Key(Id_Professor)
	References Professor(Id_Professor));

Create table Presença(
Id_Matricula int not null, 
matricula int,
nome varchar(50),
constraint fk_idMatricula foreign key (id_matricula) references aluno(id_matricula) 
);

Create table chamada( -- tabela em que o sistema vê quais alunos estão presentes 
Id_matricula int not null, 
matricula int, 
nome varchar(50), 
constraint FK_ID_Matrícula foreign key (id_matricula) references aluno(id_matricula));




insert into Aluno values ('1',0002, "Iago Benone da Silva", "IagoBenone@gmail.com", '081997636205', "M", '2001-01-23');
insert into Aluno values ('2', 0003,"Matheus Antônio Barreto de Abreu", "MatheusAntonio@hotmail.com", '081999990554', "M", '1999-02-22');
insert into Aluno values ('3', 0004,"Mariana Alves de Queiroz", "MarianaAlves@outlook.com.br", '081997123405', "F", '1998-05-14');
insert into Aluno values ('4', 0005,"Marcio Prestini", "MarcioPrest@gmail.com", '081998566205', "M", '1999-03-02');
insert into Aluno values ('5', 0006,"Huguinho", "Huguinho@gmail.com", '081998566123', "M", '1999-01-12');
insert into Aluno values ('6', 0007, "zezinho", "Zezinho@gmail.com", '081993456205', "M", '1999-02-02');
insert into Aluno values ('7', 0008,"luizinho", "Luizinho@gmail.com", '08199842505', "M", '1999-06-07');
insert into Aluno values ('8', 0009,"Felipa", "Felipa@gmail.com", '081999867205', "F", '1999-01-04');

insert into Professor values ('1', "Renan Costa Alencar", "Práticas em Banco de dados");
insert into Professor values ('2', "Diego Ribeiro", "Sistemas Operacionais");
insert into Professor values ('3', "Weberth de Souza", "Interface Humano Computador" );
insert into Professor values ('4', "Diogenes Carvalho", "Práticas de Engenharia de Software");

insert into sala values('1');
insert into sala values('2');
insert into sala values('3');
insert into sala values('4');


Insert into Instituicao values ('1', '2', '1');
Insert into Instituicao values ('2', '2', '1');
Insert into Instituicao values ('3', '4','4');
Insert into Instituicao values ('4', '3','2');
Insert into Instituicao values ('5', '4','4');
Insert into Instituicao values ('6', '4','4');
Insert into Instituicao values ('7', '4','4');
Insert into Instituicao values ('8', '1', '1');
  
  
Insert into chamada values (2, 0003,"Matheus Antônio Barreto de Abreu");
  
create temporary table proftmp select *from professor;
explain proftmp;

select* from aluno;
select* from professor;
select* from sala;
select* from instituicao;


-- Verificar os alunos cadastrados na instituição --
Select nome from Aluno;

-- Procurar na tabela "Aluno" os alunos com o nome Iago --
Select nome from Aluno where nome like "%Iago%";

-- Saber quais alunos do sexo masculino pertencem à instituição --
Select nome from Aluno where sexo = 'M';

-- Saber quais alunos possuem aula com um determinado professor --
SELECT Aluno.id_Matricula, Aluno.nome, instituicao.id_Professor FROM aluno INNER JOIN instituicao
    ON aluno.id_matricula = instituicao.id_matricula
    WHERE id_Professor  = "4";
    
-- Saber quais alunos possuem DDD relacionado a 081 --
Select nome, telefone from Aluno where telefone like "%081%";

-- Saber todos dados dos alunos e suas respectivas salas e professores --
    Select * from Aluno right join instituicao on (aluno.id_matricula = instituicao.id_matricula );
    
-- Os professores com as respectivas matriculas dos alunos nas quais ele dá aula em que a disciplina seja diferente de interface humano computador
SELECT professor.id_professor, 
instituicao.id_matricula, 
       nomeprof, 
       materiaprincipal 
FROM   professor 
       RIGHT JOIN instituicao 
              ON ( professor.id_professor = instituicao.id_professor ) where materiaprincipal != "interface humano computador"
ORDER  BY nomeprof;
 
-- Esse é um exemplo de uso na variável que nós não aprovamos, pois nesse exemplo só irá retornar um Exemplo de Iago para toda a escola --
set @alunoIago :=(Select nome from Aluno where nome like "%Iago%");
select @alunoIago;

-- Exemplo de uso de variável na qual colocamos a id do professor Renan como valor 1
set @ProfRenan :=(SELECT NomeProf FROM Professor Where Id_Professor = 1); 
select @ProfRenan;

-- Exemplo de uso de uma tabela temporária, na qual irá demonstrar todas as variáveis na tabela Aluno
Create temporary table VariaveisAlunos Select *From Aluno;
Explain VariaveisAlunos;

-- Exemplo de uso de uma tabela temporária, na qual irá demonstrar todas as variáveis na tabela professor
create temporary table VariaveisProf select *from professor;
explain VariaveisProf;

-- Criando procedure 

DELIMITER $$

CREATE PROCEDURE SelecTodosAlunos() -- procedure que seleciona todos os alunos cadastrados no sistema
BEGIN

SELECT *FROM aluno;

END $$


-- Comando para chamar a procedure que seleciona todos os alunos 
CALL SelecTodosAlunos();



CREATE PROCEDURE VerificarQntProf( out Id_professor int ) -- Comando verificar a quantidade de professores existentes
begin

select Count(*) INTO Id_professor from professor; 

end $$

DELIMITER ;

CALL VerificarQntProf(@total);
SELECT @total;

DELIMITER $$
CREATE Trigger presença after insert -- sempre que inserir na tabela na tabela chamada os dados do aluno serão inseridos na tabela presença constando que ele está presente
on chamada
FOR EACH ROW 
begin

Insert into presença (select * from chamada);
end $$

DELIMITER ;
select *from presença;



