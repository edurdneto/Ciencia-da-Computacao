-- =====================================================================
-- Banco de exemplo "universidade" — usado nas aulas e listas de BD.
-- SGBD: PostgreSQL
--
-- Como usar:
--   createdb universidade
--   psql -d universidade -f universidade.sql
--
-- O script pode ser executado de novo: ele apaga e recria as tabelas.
-- =====================================================================

DROP TABLE IF EXISTS matricula;
DROP TABLE IF EXISTS disciplina;
DROP TABLE IF EXISTS aluno;
DROP TABLE IF EXISTS professor;
DROP TABLE IF EXISTS curso;

CREATE TABLE curso (
    id_curso   SERIAL       PRIMARY KEY,
    nome       VARCHAR(80)  NOT NULL UNIQUE,
    turno      VARCHAR(10)  NOT NULL CHECK (turno IN ('manhã', 'tarde', 'noite'))
);

CREATE TABLE professor (
    id_professor  SERIAL        PRIMARY KEY,
    nome          VARCHAR(100)  NOT NULL,
    email         VARCHAR(100)  UNIQUE,
    titulacao     VARCHAR(20)   CHECK (titulacao IN ('especialista', 'mestre', 'doutor'))
);

CREATE TABLE aluno (
    matricula     CHAR(8)       PRIMARY KEY,
    nome          VARCHAR(100)  NOT NULL,
    email         VARCHAR(100)  UNIQUE,
    data_nasc     DATE,
    cidade        VARCHAR(60),
    id_curso      INT           NOT NULL REFERENCES curso (id_curso)
);

CREATE TABLE disciplina (
    codigo        CHAR(6)       PRIMARY KEY,
    nome          VARCHAR(80)   NOT NULL,
    carga_horaria INT           NOT NULL CHECK (carga_horaria > 0),
    id_curso      INT           NOT NULL REFERENCES curso (id_curso),
    id_professor  INT           REFERENCES professor (id_professor)
);

CREATE TABLE matricula (
    matricula     CHAR(8)       REFERENCES aluno (matricula),
    codigo        CHAR(6)       REFERENCES disciplina (codigo),
    semestre      CHAR(6)       NOT NULL,           -- ex.: '2026.2'
    nota          NUMERIC(4,2)  CHECK (nota BETWEEN 0 AND 10),
    PRIMARY KEY (matricula, codigo, semestre)
);

-- ------------------------------------------------------------- dados ---

INSERT INTO curso (nome, turno) VALUES
    ('Ciência da Computação', 'manhã'),
    ('Sistemas de Informação', 'noite'),
    ('Engenharia de Software', 'tarde');

INSERT INTO professor (nome, email, titulacao) VALUES
    ('Ana Ribeiro',     'ana.ribeiro@uni.edu.br',     'doutor'),
    ('Bruno Carvalho',  'bruno.carvalho@uni.edu.br',  'mestre'),
    ('Carla Mendes',    'carla.mendes@uni.edu.br',    'doutor'),
    ('Diego Farias',    NULL,                         'especialista');

INSERT INTO aluno (matricula, nome, email, data_nasc, cidade, id_curso) VALUES
    ('20240001', 'Lucas Almeida',    'lucas@email.com',    '2004-03-15', 'Fortaleza', 1),
    ('20240002', 'Mariana Souza',    'mariana@email.com',  '2005-07-22', 'Caucaia',   1),
    ('20240003', 'Pedro Lima',       NULL,                 '2003-11-02', 'Fortaleza', 2),
    ('20240004', 'Juliana Costa',    'juliana@email.com',  '2004-01-30', 'Maracanaú', 1),
    ('20240005', 'Rafael Oliveira',  'rafael@email.com',   '2002-09-12', 'Fortaleza', 3),
    ('20240006', 'Beatriz Rocha',    'bia@email.com',      '2005-05-05', NULL,        2),
    ('20240007', 'Gabriel Martins',  'gabriel@email.com',  '2004-12-19', 'Sobral',    1),
    ('20240008', 'Larissa Pereira',  'larissa@email.com',  '2003-08-08', 'Fortaleza', 3);

INSERT INTO disciplina (codigo, nome, carga_horaria, id_curso, id_professor) VALUES
    ('CC0101', 'Programação I',                   96, 1, 2),
    ('CC0201', 'Estruturas de Dados',             64, 1, 1),
    ('CC0301', 'Sistemas Operacionais',           64, 1, 3),
    ('CC0302', 'Fundamentos de Banco de Dados',   64, 1, 3),
    ('SI0101', 'Introdução a Sistemas de Info.',  32, 2, 4),
    ('SI0202', 'Banco de Dados',                  64, 2, NULL),
    ('ES0101', 'Engenharia de Requisitos',        64, 3, 1);

INSERT INTO matricula (matricula, codigo, semestre, nota) VALUES
    ('20240001', 'CC0101', '2024.1', 8.5),
    ('20240001', 'CC0201', '2025.1', 7.0),
    ('20240001', 'CC0301', '2026.2', NULL),
    ('20240002', 'CC0101', '2024.1', 9.5),
    ('20240002', 'CC0201', '2025.1', 9.0),
    ('20240002', 'CC0302', '2026.2', NULL),
    ('20240003', 'SI0101', '2024.1', 6.0),
    ('20240003', 'SI0202', '2025.2', 4.5),
    ('20240004', 'CC0101', '2024.1', 5.5),
    ('20240004', 'CC0201', '2025.1', 3.0),
    ('20240005', 'ES0101', '2024.2', 8.0),
    ('20240006', 'SI0101', '2025.1', 10.0),
    ('20240007', 'CC0101', '2024.1', 7.5),
    ('20240007', 'CC0301', '2026.2', NULL),
    ('20240007', 'CC0302', '2026.2', NULL);
