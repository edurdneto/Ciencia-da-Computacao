-- =====================================================================
-- Aula 10 — SQL: consultas básicas
-- Execute antes o script ../universidade.sql para criar o banco.
--
--   psql -d universidade -f consultas.sql
-- =====================================================================

-- 1. Todas as colunas de todos os cursos
SELECT * FROM curso;

-- 2. Apenas algumas colunas (projeção)
SELECT nome, cidade FROM aluno;

-- 3. Filtrando linhas (seleção): alunos de Fortaleza
SELECT nome, cidade
FROM aluno
WHERE cidade = 'Fortaleza';

-- 4. Combinando condições com AND / OR
SELECT matricula, codigo, nota
FROM matricula
WHERE nota >= 7 AND semestre = '2024.1';

-- 5. Ordenando o resultado
SELECT nome, data_nasc
FROM aluno
ORDER BY data_nasc DESC;

-- 6. Limitando a quantidade de linhas: as 3 maiores notas
SELECT matricula, codigo, nota
FROM matricula
WHERE nota IS NOT NULL
ORDER BY nota DESC
LIMIT 3;

-- 7. Faixas de valores com BETWEEN
SELECT matricula, codigo, nota
FROM matricula
WHERE nota BETWEEN 5 AND 7;

-- 8. Lista de valores com IN
SELECT nome, cidade
FROM aluno
WHERE cidade IN ('Caucaia', 'Maracanaú', 'Sobral');

-- 9. Busca por padrão com LIKE (% = qualquer sequência, _ = um caractere)
SELECT codigo, nome
FROM disciplina
WHERE nome LIKE '%Dados%';

-- 10. Valores ausentes: NULL só se testa com IS NULL / IS NOT NULL
SELECT nome, email
FROM aluno
WHERE email IS NULL;

-- 11. Removendo repetições com DISTINCT
SELECT DISTINCT cidade
FROM aluno
WHERE cidade IS NOT NULL
ORDER BY cidade;

-- 12. Renomeando colunas e calculando valores
SELECT nome AS disciplina,
       carga_horaria AS horas,
       carga_horaria / 16 AS horas_por_semana
FROM disciplina
ORDER BY horas DESC, disciplina;
