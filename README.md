# Ciência da Computação

Site das disciplinas de **Sistemas Operacionais** e **Fundamentos de Banco de Dados**: aulas, vídeos, slides, códigos e listas de exercícios.

**Acesse o site:** https://edurdneto.github.io/Ciencia-da-Computacao/

---

## Para alunos

- Todo o conteúdo está no site acima.
- O código das aulas fica na pasta [`codigo/`](codigo/). Para baixar tudo: `git clone https://github.com/edurdneto/Ciencia-da-Computacao.git`

## Para o professor: como manter o site

### Organização

```
docs/                          ← páginas do site (Markdown)
  index.md                     ← página inicial
  sistemas-operacionais/
    index.md                   ← ementa, avaliação, bibliografia
    cronograma.md
    aulas/                     ← uma página por aula
    listas/                    ← uma página por lista
    materiais.md
    arquivos/                  ← PDFs de slides e apostilas
  banco-de-dados/ ...          ← mesma estrutura
codigo/                        ← código-fonte das aulas (C, SQL, ...)
modelos/                       ← modelos prontos de aula e de lista
mkdocs.yml                     ← configuração e MENU do site
```

### Adicionar uma aula

1. Copie `modelos/modelo-aula.md` para `docs/<disciplina>/aulas/NN-tema.md` e preencha.
2. Coloque o código em `codigo/<disciplina>/aula-NN/`.
3. Coloque os slides (PDF) em `docs/<disciplina>/arquivos/`.
4. Adicione a aula ao menu na seção `nav:` do `mkdocs.yml`.
5. No cronograma, transforme o tema da aula em link.
6. Faça commit e push. O site é atualizado sozinho em cerca de 1 minuto.

### Vídeos

Suba no YouTube (pode ser "não listado") e use o bloco de vídeo do modelo, trocando `ID_DO_VIDEO` pelo código do link (o que vem depois de `v=`). Não coloque vídeos no repositório.

### Atenção

- **O repositório é público.** Não coloque gabaritos, provas ou notas aqui. Use um repositório privado para isso.
- Arquivos acima de ~20 MB: prefira as *Releases* do GitHub ou o Google Drive.

### Ver o site no seu computador antes de publicar

```bash
pip install -r requirements.txt
mkdocs serve          # abre em http://127.0.0.1:8000 e atualiza a cada alteração
```

### Publicação (configuração única)

Em **Settings → Pages → Build and deployment → Source**, selecione **GitHub Actions**. A partir daí, todo push na branch `main` publica o site (workflow em `.github/workflows/deploy.yml`).
