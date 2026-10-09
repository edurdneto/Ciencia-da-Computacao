# Lista 01 · SQL básico

!!! info "Entrega"
    **Prazo:** [dd/mm/aaaa, 23h59] · **Valor:** [x pontos] · **Como entregar:** [ex.: GitHub Classroom, SIGAA, e-mail]

    Entregue um arquivo `lista01.sql` com cada consulta precedida de um comentário com o número da questão (ex.: `-- Questão 3`).

**Conteúdo:** [Aula 01](../aulas/01-introducao.md) e [Aula 02](../aulas/02-sql-consultas.md).
**Banco:** todas as questões usam o banco [`universidade`](../index.md#banco-de-exemplo-universidade).

## Parte A — Conceitos

**1.** Explique a diferença entre um banco de dados e um SGBD. Cite dois SGBDs.

**2.** Cite três problemas de manter dados em arquivos/planilhas que um SGBD resolve e explique como ele resolve cada um.

**3.** O que é independência física de dados? Dê um exemplo.

## Parte B — Consultas

Escreva uma consulta SQL para cada item:

**4.** Nome e turno de todos os cursos.

**5.** Nome e data de nascimento dos alunos nascidos a partir de 2004, do mais novo para o mais velho.

**6.** Matrícula e nota das matrículas na disciplina `CC0101` com nota menor que 6.

**7.** Nome dos alunos que **não** moram em Fortaleza. *(Atenção: e quem não tem cidade cadastrada?)*

**8.** Código e nome das disciplinas com carga horária entre 32 e 64 horas (inclusive).

**9.** Nome e e-mail dos professores **sem** e-mail cadastrado.

**10.** Nome dos alunos cujo e-mail termina em `@email.com` e cujo nome contém a letra "a" na segunda posição.

**11.** Todas as matrículas ainda **sem nota**, ordenadas por semestre e depois por código da disciplina.

**12.** As cidades distintas dos alunos, em ordem alfabética, sem incluir valores ausentes.

**13.** Nome da disciplina e a carga horária em **créditos**, sabendo que 1 crédito = 16 horas. Dê à coluna o nome `creditos`.

## Parte C — Desafio

**14.** A consulta abaixo deveria listar os alunos sem cidade cadastrada, mas retorna zero linhas. Explique por que e corrija.

```sql
SELECT nome FROM aluno WHERE cidade = NULL;
```

**15.** Explique a diferença entre os resultados destas duas consultas:

```sql
SELECT cidade FROM aluno;
SELECT DISTINCT cidade FROM aluno;
```
