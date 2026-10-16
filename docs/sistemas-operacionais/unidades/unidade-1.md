# Unidade 1 · Introdução aos Sistemas Operacionais

<div class="resumo-aula" markdown>
[:material-presentation-play: Abrir os slides](../arquivos/unidade-1.pdf){ .md-button .md-button--primary target="_blank" }
[:material-download: Baixar PDF · 88 slides](../arquivos/unidade-1.pdf){ .md-button download }
[:material-arrow-right: Próxima: Estruturas do S.O](unidade-2.md){ .md-button }
</div>

!!! abstract "Nesta unidade"
    1. **Histórico dos sistemas operacionais** — dos primeiros computadores ao Windows, macOS e Linux.
    2. **O que fazem os sistemas operacionais** — funções básicas.
    3. **Arquitetura e organização** — hardware, kernel, modos de acesso, system calls e boot.
    4. **Tipos de S.O** — mainframe, desktop, handheld, embarcado, lotes, tempo compartilhado, tempo real, distribuído e paralelo.

## Slides

<div class="pdf-slides">
  <iframe src="../../arquivos/unidade-1.pdf#view=FitH" title="Slides da Unidade 1" loading="lazy"></iframe>
</div>

!!! tip "No celular os slides não aparecem?"
    Alguns navegadores de celular não exibem PDF dentro da página. Use o botão **Abrir os slides** acima.

## Resumo da unidade

### Parte I · Histórico dos sistemas operacionais

<span class="slides-ref">[Slides 3–21](../arquivos/unidade-1.pdf#page=3){ target="_blank" }</span>

| Período | O que marcou |
|---|---|
| **1945–1955** · S.Os primitivos | Não havia sistema operacional. Quem projetava o hardware também programava e operava a máquina. |
| **1955–1965** · Programação em *batch* | Surge o conceito de S.O: comandos executados em sequência por cartões perfurados. |
| **Meados de 1960** · Sistemas específicos | Primeiros S.Os, mas cada máquina tinha o seu, e mainframes diferentes eram incompatíveis. |
| **1969** · UNIX | Desenvolvido pela AT&T, primeiro em Assembly e reescrito em C em 1973. Considerado o primeiro S.O moderno; introduziu portabilidade, multiusuário e multitarefa. |
| **S.Os para PCs** | Apple I e Macintosh (conceito de *desktop*, interface gráfica, ícones, pastas); MS-DOS (1982); Windows. |
| **Sistemas livres** | Projeto GNU (1983, Richard Stallman) e o kernel de Linus Torvalds (1991): a base do **Linux**. |

A evolução do Windows alternou sucessos e fracassos: 95/98, ME, XP (transição para o kernel NT), Vista (primeiro multi-core da Microsoft, mas pesado), 7/8, 10 e 11.

Os slides trazem também os sistemas mais usados em 2026: **Windows** (72,1%), **macOS** (15,4%), **Linux** (4,03%) e **Chrome OS** (2,27%).

### O que é e o que faz um sistema operacional

<span class="slides-ref">[Slides 22–26](../arquivos/unidade-1.pdf#page=22){ target="_blank" }</span>

!!! quote "Definição"
    O sistema operacional é um software, ou conjunto de softwares, cuja função é **administrar e gerenciar os recursos de um sistema**, desde componentes de hardware e sistemas de arquivos a programas de terceiros, estabelecendo a **interface entre o computador e o usuário**.

!!! tip "Dica para memorizar"
    Pense no S.O como o **"Gerente Geral" de uma empresa**. Sem ele, os funcionários (aplicativos) não sabem quem usa as mesas (memória) ou os telefones (processador).

Funções básicas:

- facilidade de acesso aos recursos do sistema;
- compartilhamento de recursos de forma organizada e protegida;
- **comunicação** entre usuário, aplicação e hardware;
- **controle** da concorrência pelos recursos.

### Parte II · Arquitetura e organização dos sistemas computacionais

<span class="slides-ref">[Slides 27–49](../arquivos/unidade-1.pdf#page=27){ target="_blank" }</span>

**Lei de Moore.** O número de transistores em um circuito integrado dobra a cada dois anos (Gordon Moore, 1965; revisada em 1975). Para os S.Os, isso viabilizou a multitarefa, levou à era multi-core (exigindo gerenciar paralelismo e escalonamento) e permitiu recursos complexos como criptografia em tempo real e virtualização.

**Conceitos básicos de hardware:**

| Componente | Descrição |
|---|---|
| Processador | Executa instruções em linguagem de máquina. |
| Memória principal (RAM) | Memória volátil e de acesso aleatório. |
| Registradores | Muito rápidos, ficam dentro do processador, guardam dados para uso imediato. |
| Cache | Dividida em L1, L2 e às vezes L3, integrada aos processadores. |
| Armazenamento secundário | Mais lento e com maior capacidade (discos, CD, DVD). |
| Dispositivos de E/S | Recebem ou transmitem informações (mouse, impressora, monitor...). |

**Estrutura de um S.O:** núcleo (*kernel*), código de inicialização, *drivers* (código específico para acessar um dispositivo — um "tradutor") e programas utilitários.

**Kernel.** É o elo entre o hardware e o software. Suas rotinas são executadas **concorrentemente**, e suas principais funções são:

<div class="grid" markdown>

- tratamento de interrupções e exceções;
- criação e eliminação de processos e threads;
- sincronização e comunicação entre processos e threads;
- escalonamento e controle dos processos e threads;
- gerência de memória;

- gerência do sistema de arquivos;
- gerência de dispositivos de E/S;
- suporte a redes locais e distribuídas;
- contabilização do uso do sistema;
- auditoria e segurança do sistema.

</div>

**Modos de acesso.** Para proteger o núcleo, o processador tem dois modos:

| Modo usuário | Modo kernel |
|---|---|
| A aplicação só executa instruções **não privilegiadas** (um conjunto reduzido). | A aplicação tem acesso ao **conjunto total** de instruções do processador. |

**System calls.** As funções do núcleo são rotinas com instruções privilegiadas. Sempre que uma aplicação quer chamar uma rotina do S.O, o mecanismo de *system call* é ativado — ele é a **porta de entrada** para o núcleo. O termo é típico do Unix; no Windows, o conceito aparece como API (*Application Program Interface*).

**Componentes de um S.O:**

| Componente | Função |
|---|---|
| Escalonador de processos | Decide quando e por quanto tempo um processo usa o processador. |
| Gerenciador de memória | Decide quando e como a memória é cedida aos processos, e o que fazer quando ela enche. |
| Gerenciador de E/S | Atende às solicitações de entrada e saída dos dispositivos. |
| Gerenciador de comunicação (IPC) | Permite que os processos se comuniquem entre si. |
| Gerenciador de sistema de arquivos | Organiza os dados gravados nos dispositivos e dá acesso a eles. |

**Boot (ativação) e shutdown.** Ao ligar o computador, os componentes do S.O são carregados para a memória principal. O processo começa com o **boot loader**, em um endereço fixo da ROM, que chama o **POST** (*Power-On Self Test*) para identificar problemas de hardware. O **shutdown** desativa aplicações e componentes de forma ordenada, garantindo sua integridade.

### Parte III · Tipos de sistemas operacionais

<span class="slides-ref">[Slides 50–87](../arquivos/unidade-1.pdf#page=50){ target="_blank" }</span>

| Tipo | Características principais | Exemplos dos slides |
|---|---|---|
| **Mainframe** | Grande porte; milhares de usuários simultâneos, enorme volume de transações, funcionamento contínuo e alta segurança. Trabalha em *batch* e *time-sharing*. | Bancos (Pix, saques, pagamentos), operadoras de cartão, companhias aéreas |
| **Desktop** | Computador pessoal, geralmente de um único usuário. Foco em **interatividade** e boa experiência de uso. | — |
| **Handheld** | Dispositivos portáteis com **restrição de recursos**: pouca memória, bateria limitada, tela pequena. O S.O precisa ser muito eficiente. | Smartphones e tablets |
| **Embarcado** | Computador integrado a um equipamento maior, para uma função específica, com limitações ainda maiores. | Freio ABS, máquina de lavar, roteadores, IoT (TinyOS, FreeRTOS, Contiki) |
| **Lotes (*batch*)** | Primeiro tipo de S.O. *Jobs* semelhantes agrupados em lotes e executados em sequência, **sem interação**. Alta vazão, mas tempo de resposta pode ser alto. | Folha de pagamento, relatório mensal |
| **Tempo compartilhado** | Vários usuários interagem ao mesmo tempo; a CPU alterna rapidamente entre eles (fatias de tempo). Baixo tempo de resposta, arquitetura mais complexa, memória virtual. | Mainframe de universidade com terminais |
| **Tempo real** | O resultado depende da resposta lógica **e** do cumprimento de prazos. *Hard real-time*: atraso é catastrófico. *Soft real-time*: atraso só reduz a qualidade. | Controle de voo (hard); multimídia (soft) |
| **Distribuído** | Computadores independentes que parecem um único sistema; fracamente acoplados (cliente-servidor ou P2P). | Comércio eletrônico, Skype clássico, blockchain |
| **Paralelo (SMP)** | CPUs compartilham barramento, memória e relógio (fortemente acoplados). Cada processador roda uma cópia idêntica do S.O, sem mestre/escravo. | A maioria dos S.Os modernos |

!!! example "Lotes × tempo compartilhado"
    | | Lotes (multiprogramação) | Tempo compartilhado |
    |---|---|---|
    | Objetivo principal | Maximizar o uso do processador (*throughput*) | Minimizar o tempo de resposta |
    | Fonte das diretivas | *Job control language*, comandos enviados com o job | Comandos via terminal |

**Classificações finais:** quanto ao número de usuários (**monousuário** ou **multiusuário**) e quanto ao número de tarefas (**monotarefa** ou **multitarefa**).

## Para pensar

!!! question "Dica de filme"
    Os slides sobre os S.Os primitivos recomendam o filme **"O Jogo da Imitação"**.
