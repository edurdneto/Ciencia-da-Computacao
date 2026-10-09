-- =====================================================================
-- Aula 02 — Fundamentos de bancos de dados e SGBDs
-- Primeiro contato com SQL: esquema, instância, integridade e transação.
-- SGBD: PostgreSQL
--
-- Como usar:
--   createdb aula02
--   psql -d aula02 -f primeiro-contato.sql
--
-- O script pode ser executado de novo: ele apaga e recria as tabelas.
-- =====================================================================

DROP TABLE IF EXISTS produto;
DROP TABLE IF EXISTS conta;

-- ---------------------------------------------------------------------
-- 1. DDL: definir a estrutura (o ESQUEMA, guardado no catálogo)
-- ---------------------------------------------------------------------
CREATE TABLE produto (
    id_produto INTEGER       PRIMARY KEY,
    nome       VARCHAR(120)  NOT NULL,
    preco      NUMERIC(10,2) NOT NULL CHECK (preco >= 0)
);

-- ---------------------------------------------------------------------
-- 2. DML: construir e manipular a INSTÂNCIA
-- ---------------------------------------------------------------------
INSERT INTO produto (id_produto, nome, preco)
VALUES (1, 'Teclado', 79.90),
       (2, 'Mouse',   39.90),
       (3, 'Monitor', 850.00);

SELECT nome, preco FROM produto WHERE preco >= 50.00;

UPDATE produto SET preco = 89.90 WHERE id_produto = 1;

DELETE FROM produto WHERE id_produto = 2;

SELECT * FROM produto ORDER BY id_produto;

-- ---------------------------------------------------------------------
-- 3. Os metadados também podem ser consultados
--    (o catálogo descreve as colunas da tabela produto)
-- ---------------------------------------------------------------------
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'produto'
ORDER BY ordinal_position;

-- ---------------------------------------------------------------------
-- 4. Integridade em ação: esta inserção DEVE falhar (preço negativo)
-- ---------------------------------------------------------------------
INSERT INTO produto (id_produto, nome, preco)
VALUES (4, 'Cabo', -10.00);

-- ---------------------------------------------------------------------
-- 5. Transação: transferir R$ 50,00 da conta A para a conta B
-- ---------------------------------------------------------------------
CREATE TABLE conta (
    id    CHAR(1)       PRIMARY KEY,
    saldo NUMERIC(10,2) NOT NULL CHECK (saldo >= 0)
);
INSERT INTO conta VALUES ('A', 200.00), ('B', 100.00);

-- 5a. Caminho feliz: débito + crédito + COMMIT
BEGIN;
UPDATE conta SET saldo = saldo - 50 WHERE id = 'A';
UPDATE conta SET saldo = saldo + 50 WHERE id = 'B';
COMMIT;

SELECT id, saldo FROM conta ORDER BY id;

-- 5b. Algo deu errado no meio: ROLLBACK desfaz o débito
BEGIN;
UPDATE conta SET saldo = saldo - 50 WHERE id = 'A';
-- (imagine que o programa falhou aqui, antes do crédito em B)
ROLLBACK;

SELECT id, saldo FROM conta ORDER BY id;

-- 5c. A restrição CHECK (saldo >= 0) impede transferir mais do que existe:
--     o débito falha e a transação inteira é abortada.
BEGIN;
UPDATE conta SET saldo = saldo - 500 WHERE id = 'A';
UPDATE conta SET saldo = saldo + 500 WHERE id = 'B';
COMMIT;   -- no PostgreSQL, COMMIT de uma transação com erro vira ROLLBACK

SELECT id, saldo FROM conta ORDER BY id;
