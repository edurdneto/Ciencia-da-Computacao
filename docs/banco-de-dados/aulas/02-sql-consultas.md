# Aula 02 · SQL: consultas básicas

<div class="resumo-aula" markdown>
[:material-file-pdf-box: Slides (em breve)](#){ .md-button }
[:material-github: Código da aula](https://github.com/edurdneto/Ciencia-da-Computacao/tree/main/codigo/banco-de-dados/aula-02){ .md-button }
[:material-pencil: Lista 01](../listas/lista-01.md){ .md-button .md-button--primary }
</div>

!!! abstract "Objetivos"
    Ao final desta aula você será capaz de:

    - Escrever consultas com `SELECT`, `FROM` e `WHERE`.
    - Filtrar com operadores de comparação, `AND`, `OR`, `BETWEEN`, `IN` e `LIKE`.
    - Tratar valores ausentes (`NULL`) corretamente.
    - Ordenar (`ORDER BY`), limitar (`LIMIT`) e remover repetições (`DISTINCT`).

## Vídeo da aula

<!--
PROFESSOR: troque o bloco "Vídeo em breve" por:
<div class="video">
  <iframe src="https://www.youtube-nocookie.com/embed/ID_DO_VIDEO" title="Aula 02 · SQL" allowfullscreen></iframe>
</div>
-->

!!! note "Vídeo em breve"
    A gravação desta aula será publicada aqui.

## Antes de começar

Crie o banco de exemplo `universidade` (veja a [página da disciplina](../index.md#banco-de-exemplo-universidade)):

```bash
createdb universidade
psql -d universidade -f codigo/banco-de-dados/universidade.sql
psql -d universidade      # abre o terminal interativo
```

## 1. A estrutura de uma consulta

```sql
SELECT colunas      -- o QUE eu quero ver
FROM tabela         -- DE ONDE vêm os dados
WHERE condição      -- QUAIS linhas (opcional)
ORDER BY colunas;   -- em que ORDEM (opcional)
```

!!! tip "A ordem de escrita não é a ordem de execução"
    O SGBD primeiro lê a tabela (`FROM`), depois filtra as linhas (`WHERE`), escolhe as colunas (`SELECT`) e por fim ordena (`ORDER BY`). Por isso um apelido criado no `SELECT` pode ser usado no `ORDER BY`, mas não no `WHERE`.

## 2. Escolhendo colunas (projeção)

=== "Consulta"

    ```sql
    SELECT nome, cidade FROM aluno;
    ```

=== "Resultado"

    ```text
          nome       |  cidade
    -----------------+-----------
     Lucas Almeida   | Fortaleza
     Mariana Souza   | Caucaia
     Pedro Lima      | Fortaleza
     Juliana Costa   | Maracanaú
     Rafael Oliveira | Fortaleza
     Beatriz Rocha   |
     Gabriel Martins | Sobral
     Larissa Pereira | Fortaleza
    (8 rows)
    ```

`SELECT *` traz todas as colunas. É prático para explorar, mas em programas prefira listar as colunas que você realmente usa.

## 3. Filtrando linhas (seleção)

=== "Consulta"

    ```sql
    SELECT matricula, codigo, nota
    FROM matricula
    WHERE nota >= 7 AND semestre = '2024.1';
    ```

=== "Resultado"

    ```text
     matricula | codigo | nota
    -----------+--------+------
     20240001  | CC0101 | 8.50
     20240002  | CC0101 | 9.50
     20240007  | CC0101 | 7.50
    (3 rows)
    ```

| Operador | Significado | Exemplo |
|---|---|---|
| `=` `<>` | igual, diferente | `cidade <> 'Fortaleza'` |
| `<` `<=` `>` `>=` | comparação | `nota >= 7` |
| `AND` `OR` `NOT` | lógica | `nota >= 7 AND semestre = '2024.1'` |
| `BETWEEN a AND b` | faixa (inclui os extremos) | `nota BETWEEN 5 AND 7` |
| `IN (...)` | está na lista | `cidade IN ('Caucaia', 'Sobral')` |
| `LIKE` | padrão de texto | `nome LIKE '%Dados%'` |

!!! info "Curingas do `LIKE`"
    `%` casa com **qualquer sequência** de caracteres (inclusive nenhuma) e `_` casa com **exatamente um** caractere. `'Ma%'` casa com "Mariana" e "Maracanaú"; `'_e%'` casa com nomes cuja segunda letra é "e". No PostgreSQL, `ILIKE` faz o mesmo ignorando maiúsculas/minúsculas.

## 4. Cuidado com o `NULL`

`NULL` significa **"valor desconhecido"** — não é zero nem texto vazio. Qualquer comparação com `NULL` usando `=` resulta em *desconhecido*, e a linha **não** aparece.

=== "❌ Errado"

    ```sql
    SELECT nome FROM aluno WHERE email = NULL;   -- sempre retorna 0 linhas!
    ```

=== "✅ Certo"

    ```sql
    SELECT nome, email FROM aluno WHERE email IS NULL;
    ```

    ```text
        nome    | email
    ------------+-------
     Pedro Lima |
    (1 row)
    ```

## 5. Ordenando e limitando

=== "Consulta"

    ```sql
    -- As 3 maiores notas
    SELECT matricula, codigo, nota
    FROM matricula
    WHERE nota IS NOT NULL
    ORDER BY nota DESC
    LIMIT 3;
    ```

=== "Resultado"

    ```text
     matricula | codigo | nota
    -----------+--------+-------
     20240006  | SI0101 | 10.00
     20240002  | CC0101 |  9.50
     20240002  | CC0201 |  9.00
    (3 rows)
    ```

??? question "Por que o `WHERE nota IS NOT NULL`?"
    No PostgreSQL, `NULL` é considerado **maior** que qualquer valor na ordenação. Com `ORDER BY nota DESC`, as matrículas sem nota (disciplinas em andamento) apareceriam primeiro. Outra solução é `ORDER BY nota DESC NULLS LAST`.

## 6. Removendo repetições e criando colunas

=== "DISTINCT"

    ```sql
    SELECT DISTINCT cidade
    FROM aluno
    WHERE cidade IS NOT NULL
    ORDER BY cidade;
    ```

    ```text
      cidade
    -----------
     Caucaia
     Fortaleza
     Maracanaú
     Sobral
    (4 rows)
    ```

=== "Apelidos e cálculos"

    ```sql
    SELECT nome AS disciplina,
           carga_horaria AS horas,
           carga_horaria / 16 AS horas_por_semana
    FROM disciplina
    ORDER BY horas DESC, disciplina;
    ```

    ```text
               disciplina           | horas | horas_por_semana
    --------------------------------+-------+------------------
     Programação I                  |    96 |                6
     Banco de Dados                 |    64 |                4
     Engenharia de Requisitos       |    64 |                4
     Estruturas de Dados            |    64 |                4
     Fundamentos de Banco de Dados  |    64 |                4
     Sistemas Operacionais          |    64 |                4
     Introdução a Sistemas de Info. |    32 |                2
    (7 rows)
    ```

## Todas as consultas da aula

O arquivo completo, para rodar de uma vez com `psql -d universidade -f consultas.sql`:

??? example "codigo/banco-de-dados/aula-02/consultas.sql"
    ```sql linenums="1"
    --8<-- "codigo/banco-de-dados/aula-02/consultas.sql"
    ```

## Para praticar

1. Liste nome e e-mail dos professores com titulação de doutor.
2. Liste as disciplinas com carga horária maior que 60 horas, da maior para a menor.
3. Quais alunos têm nome começando com a letra "L"?

??? success "Respostas"
    ```sql
    -- 1
    SELECT nome, email FROM professor WHERE titulacao = 'doutor';
    -- 2
    SELECT nome, carga_horaria FROM disciplina
    WHERE carga_horaria > 60 ORDER BY carga_horaria DESC;
    -- 3
    SELECT nome FROM aluno WHERE nome LIKE 'L%';
    ```

Os exercícios avaliados estão na [Lista 01](../listas/lista-01.md).

## Leitura recomendada

- Elmasri & Navathe, *Sistemas de Banco de Dados*, capítulo 6.
- [Tutorial do PostgreSQL: consultas](https://www.postgresql.org/docs/current/tutorial-select.html).
