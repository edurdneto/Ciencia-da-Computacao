# Unidade 4 · Threads

<div class="resumo-aula" markdown>
[:material-presentation-play: Abrir os slides](../arquivos/unidade-4.pdf){ .md-button .md-button--primary target="_blank" }
[:material-download: Baixar PDF · 48 slides](../arquivos/unidade-4.pdf){ .md-button download }
[:material-arrow-right: Próxima: Sincronização](unidade-5.md){ .md-button }
</div>

!!! abstract "Nesta unidade"
    1. **Visão geral de threads** — conceito, estrutura e benefícios
    2. **Programação multicore** — concorrência × paralelismo, desafios e Lei de Amdahl
    3. **Modelos de geração de multithreads** — muitos-para-um, um-para-um e muitos-para-muitos

## Slides

<div class="pdf-slides">
  <iframe src="../../arquivos/unidade-4.pdf#view=FitH" title="Slides da Unidade 4" loading="lazy"></iframe>
</div>

!!! tip "No celular os slides não aparecem?"
    Alguns navegadores de celular não exibem PDF dentro da página. Use o botão **Abrir os slides** acima.

## Resumo da unidade

### Parte I · Visão geral de threads

<span class="slides-ref">[Slides 2–18](../arquivos/unidade-4.pdf#page=2){ target="_blank" }</span>

Uma **thread** é a **unidade básica de utilização da CPU**, composta por:

1. ID de thread
2. Contador de programa
3. Conjunto de registradores
4. Pilha

Threads do mesmo processo **compartilham** a seção de código, a seção de dados e outros recursos do S.O, como arquivos abertos e sinais.

| Processo (*heavyweight*) | Thread (*lightweight*) |
|---|---|
| Espaço de memória próprio e isolado | Compartilha código, dados e recursos do processo |
| Troca de contexto lenta e cara | Troca de contexto rápida |
| Se falha, os outros não são afetados diretamente | Se falha criticamente, pode afetar todo o processo |
| Comunicação (IPC) exige mecanismos do S.O | Comunicação direta pela memória compartilhada |

!!! example "Exemplos de aplicação"
    - **Navegador web:** uma thread exibe imagens e texto, outra busca dados na rede.
    - **Processador de textos:** uma thread exibe a tela, outra responde ao teclado, outra verifica a ortografia em segundo plano.
    - **Servidor web:** com uma única thread, atende um cliente por vez. Antes das threads, criava-se **um processo por requisição** — caro de criar, com comunicação lenta e código duplicado. Com várias threads, o servidor cria uma thread para escutar requisições e outras para atendê-las.

**Benefícios das threads:**

| Benefício | Significado |
|---|---|
| **Capacidade de resposta** | A aplicação continua respondendo mesmo com parte dela bloqueada ou em uma operação demorada. |
| **Compartilhamento de recursos** | Threads compartilham memória e recursos do processo por padrão; processos precisam de memória compartilhada ou mensagens. |
| **Economia** | No Solaris, criar um processo é cerca de **30×** mais lento que criar uma thread, e a troca de contexto cerca de **5×** mais lenta. |
| **Escalabilidade** | Threads podem executar em paralelo em núcleos diferentes; um processo de thread única usa só um processador. |

### Parte II · Programação multicore

<span class="slides-ref">[Slides 19–39](../arquivos/unidade-4.pdf#page=19){ target="_blank" }</span>

Os sistemas evoluíram de uma CPU para várias CPUs e, depois, para **vários núcleos em um único chip** (*multicore*).

=== "Concorrência (núcleo único)"

    ```text
    núcleo único │ T1 │ T2 │ T3 │ T4 │ T1 │ T2 │ T3 │ T4 │ ...
                 └────────────────── tempo ──────────────────▶
    ```

    As tarefas **progridem intercalando** a execução no tempo.

=== "Paralelismo (múltiplos núcleos)"

    ```text
    núcleo 1 │ T1 │ T3 │ T1 │ T3 │ T1 │ ...
    núcleo 2 │ T2 │ T4 │ T2 │ T4 │ T2 │ ...
             └──────── tempo ────────▶
    ```

    As tarefas executam **ao mesmo tempo** em núcleos separados.

- Um sistema é **paralelo** quando executa mais de uma tarefa simultaneamente.
- Um sistema é **concorrente** quando dá suporte a mais de uma tarefa, permitindo que todas progridam.
- **É possível haver concorrência sem paralelismo** — como nos computadores de núcleo único.

**Desafios da programação multicore:**

1. **Identificação de tarefas** — encontrar partes independentes que possam rodar em paralelo.
2. **Equilíbrio** — as tarefas devem ter esforço semelhante; às vezes não vale usar um núcleo para uma tarefa pequena.
3. **Divisão de dados** — os dados também precisam ser divididos entre os núcleos.
4. **Dependência de dados** — quando uma tarefa depende de outra, é preciso **sincronizar**.
5. **Teste e depuração** — muito mais difíceis com vários caminhos de execução.

!!! warning "Sincronização: necessária, mas com custo"
    Sem sincronização há **condição de corrida** (ex.: duas threads atualizando o mesmo saldo bancário). Com sincronização em excesso, as threads esperam em fila pela mesma trava e o processamento paralelo vira **serial**.

**Lei de Amdahl.** Calcula o ganho de desempenho potencial ao adicionar núcleos:

<div class="formula">aceleração ≤ <span class="frac"><span>1</span><span>S + (1 − S) / N</span></span></div>

onde **S** é a fração serial da aplicação, **(1 − S)** a fração paralelizável e **N** o número de núcleos.

| Exemplo dos slides | Resultado |
|---|---|
| 25% serial, **2 núcleos** | aceleração de **1,6×** |
| 25% serial, **4 núcleos** | aceleração de **2,28×** — não dobra, por causa da parte serial |
| 40% serial, **N → ∞** | o limite é 1 / S = 1 / 0,4 = **2,5×** |

**Tipos de paralelismo:**

| Paralelismo de dados | Paralelismo de tarefas |
|---|---|
| Distribui **subconjuntos dos mesmos dados** pelos núcleos; cada núcleo faz **a mesma operação** | Distribui **tarefas diferentes** (threads) pelos núcleos; cada thread faz uma operação própria |
| Ex.: matrizes, vetores, operações em lote | As threads podem usar os mesmos dados ou dados diferentes |

### Parte III · Modelos de geração de multithreads

<span class="slides-ref">[Slides 40–48](../arquivos/unidade-4.pdf#page=40){ target="_blank" }</span>

O suporte a threads existe em dois níveis:

- **Threads de usuário** — gerenciadas por uma **biblioteca** no espaço do usuário, sem suporte do kernel.
- **Threads de kernel** — gerenciadas e escalonadas diretamente pelo **S.O**.

Os modelos definem como threads de usuário são mapeadas em threads de kernel:

| Modelo | Mapeamento | Vantagens | Desvantagens |
|---|---|---|---|
| **Muitos-para-um** | Muitas threads de usuário → **1** thread de kernel | Criação e troca de contexto muito eficientes | Uma chamada bloqueadora **bloqueia o processo inteiro**; não aproveita multicore; pouco usado hoje |
| **Um-para-um** | Cada thread de usuário → **1** thread de kernel | Mais concorrência; outra thread executa se uma bloquear; paralelismo em multiprocessadores | Cada thread de usuário exige criar uma thread de kernel — por isso o número de threads costuma ser limitado |
| **Muitos-para-muitos** | Muitas threads de usuário → número **menor ou igual** de threads de kernel | Cria quantas threads de usuário quiser; threads de kernel em paralelo; se uma bloqueia, o kernel escala outra | — |
| **Dois níveis** | Variação do muitos-para-muitos que também permite **vincular** uma thread de usuário a uma de kernel | Flexibilidade + garantia para threads críticas | — |

## Para pensar

!!! question "Perguntas propostas nos slides"
    1. **Slide 7:** como seria o navegador ou o processador de textos se tudo rodasse em **uma única thread**?
    2. **Slides 28–31:** como dividir um **contador de palavras** em tarefas concorrentes? *(Os slides propõem três etapas: leitura e divisão, contagem parcial e consolidação.)* Como garantir tarefas balanceadas e independentes?
    3. **Slides 32–34:** como balancear a carga entre os núcleos? Como dividir os dados mantendo a corretude? Como sincronizar **sem** criar gargalos?
