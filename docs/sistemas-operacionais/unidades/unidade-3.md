# Unidade 3 · Processos

<div class="resumo-aula" markdown>
[:material-presentation-play: Abrir os slides](../arquivos/unidade-3.pdf){ .md-button .md-button--primary target="_blank" }
[:material-download: Baixar PDF · 116 slides](../arquivos/unidade-3.pdf){ .md-button download }
[:material-arrow-right: Próxima: Threads](unidade-4.md){ .md-button }
</div>

!!! abstract "Nesta unidade"
    1. **Conceito de processo**
    2. **Estados do processo** e o bloco de controle de processo (PCB)
    3. **Escalonador de processos** — filas, schedulers e mudança de contexto
    4. **Operações sobre processos** — criação e encerramento
    5. **Comunicação interprocessos** — memória compartilhada e troca de mensagens

## Slides

<div class="pdf-slides">
  <iframe src="../../arquivos/unidade-3.pdf#view=FitH" title="Slides da Unidade 3" loading="lazy"></iframe>
</div>

!!! tip "No celular os slides não aparecem?"
    Alguns navegadores de celular não exibem PDF dentro da página. Use o botão **Abrir os slides** acima.

## Resumo da unidade

### Parte I · Conceito de processo

<span class="slides-ref">[Slides 3–19](../arquivos/unidade-3.pdf#page=3){ target="_blank" }</span>

Um **processo** é um **programa em execução**. Ele precisa de recursos (CPU, memória, arquivos, dispositivos de E/S), alocados quando é criado ou durante a execução. O sistema é formado por **processos do S.O** (gerenciam o hardware) e **processos de usuário** (seus aplicativos).

Os primeiros computadores executavam um programa por vez, com controle total da máquina. Com a **multiprogramação**, vários programas passaram a ficar na memória e executar concorrentemente, o que exigiu mais controle e compartimentalização — daí surgiu o conceito de processo.

Um processo é composto por:

| Parte | Conteúdo |
|---|---|
| **Seção de texto** | O código do programa |
| **Atividade corrente** | Contador de programa e registradores do processador |
| **Pilha** | Dados temporários: parâmetros de funções, endereços de retorno, variáveis locais |
| **Seção de dados** | Variáveis globais e estáticas |
| **Heap** | Memória alocada dinamicamente durante a execução |

!!! warning "Vale destacar"
    Um **programa** é uma entidade **passiva** (um arquivo executável no disco). Um **processo** é uma entidade **ativa**, com um contador de programa e recursos associados. O programa vira processo quando o executável é **carregado na memória**.

    Um processo também pode ser ambiente de execução para outro código: o comando `java` executa a **JVM** como um processo comum, e ela executa o programa Java.

### Parte II · Estado do processo e PCB

<span class="slides-ref">[Slides 20–38](../arquivos/unidade-3.pdf#page=20){ target="_blank" }</span>

| Estado | Significado |
|---|---|
| **Novo** | O processo está sendo criado. |
| **Em execução** | Instruções estão sendo executadas. |
| **Em espera** | Esperando algum evento (conclusão de I/O, recebimento de um sinal). |
| **Pronto** | Esperando ser atribuído a um processador. |
| **Concluído** | Terminou sua execução. |

Apenas **um processo** pode estar em execução em cada processador a cada instante, mas muitos podem estar prontos e em espera.

**Bloco de controle de processo (PCB).** Cada processo é representado no S.O por um PCB, com:

- estado do processo e número do processo;
- contador do programa (endereço da próxima instrução);
- **registradores da CPU** — salvos em toda interrupção, para o processo continuar de onde parou;
- informações de **scheduling** (prioridade, ponteiros para filas);
- informações de **gerenciamento de memória** (registradores base e limite, tabelas de páginas ou segmentos);
- informações de **contabilização** (tempo de CPU usado, limites, números de jobs);
- informações de **status de I/O** (dispositivos alocados, arquivos abertos).

**Threads.** No modelo tradicional, um processo tem um único *thread* de controle: no editor de texto, não daria para digitar e rodar o corretor ortográfico ao mesmo tempo. Os S.Os modernos permitem **vários threads por processo**, especialmente úteis em sistemas multicore; o PCB passa a guardar informações de cada thread. *(Tema da [Unidade 4](unidade-4.md).)*

### Parte III · Scheduling (escalonamento) de processos

<span class="slides-ref">[Slides 39–67](../arquivos/unidade-3.pdf#page=39){ target="_blank" }</span>

- **Multiprogramação:** ter sempre algum processo executando, para maximizar o uso da CPU.
- **Tempo compartilhado:** alternar a CPU entre processos com frequência suficiente para o usuário interagir com cada um.

O **scheduler** escolhe qual processo disponível vai para a CPU. Em um monoprocessador, só um processo executa por vez.

**Filas de scheduling:**

| Fila | O que contém |
|---|---|
| **Fila de jobs** | Todos os processos do sistema |
| **Fila de prontos** | Processos na memória principal, prontos e esperando a CPU — uma lista encadeada de PCBs |
| **Filas de dispositivos** | Processos esperando um dispositivo de E/S; cada dispositivo tem a sua |

Um processo na CPU pode: **pedir E/S** (vai para uma fila de dispositivo), **criar um filho** e esperar seu término, ou ser **interrompido** e voltar à fila de prontos. O ciclo se repete até ele terminar, quando sai de todas as filas e tem seu PCB e recursos desalocados.

**Tipos de scheduler:**

| Scheduler | Função | Frequência |
|---|---|---|
| **Longo prazo** (*job scheduler*) | Decide quais programas entram no sistema (disco → memória); controla o **grau de multiprogramação** e busca um bom **mix** de processos *I/O-bound* e *CPU-bound* | Baixa (minutos) |
| **Curto prazo** (*CPU scheduler*) | Escolhe qual processo pronto recebe a CPU (memória → CPU) | Altíssima (ex.: a cada 100 ms) — precisa ser muito rápido |
| **Médio prazo** | Remove processos da memória para o disco (**swap-out**) e os traz de volta depois (**swap-in**) — o *swapping* | Intermediária |

!!! example "Por que o scheduler de curto prazo precisa ser rápido"
    Se ele leva 10 ms para decidir e o processo executa por 100 ms, então 10 / (100 + 10) ≈ **9%** da CPU é gasto só organizando o trabalho.

**Mudança de contexto.** Para trocar de processo, o S.O **salva** o contexto do processo atual (registradores, estado, informações de memória) no seu PCB e **restaura** o do próximo. Esse tempo é **puro overhead**: nenhum trabalho útil é feito durante a troca.

**Multitarefa em dispositivos móveis.** No início, só o app em primeiro plano executava. O iOS 4 permitiu multitarefa limitada (áudio, localização, VoIP); o Android usa **serviços** que continuam em segundo plano. Hoje ambos fazem multitarefa com poucas restrições, usando threads.

### Parte IV · Operações sobre processos

<span class="slides-ref">[Slides 68–84](../arquivos/unidade-3.pdf#page=68){ target="_blank" }</span>

**Criação.** Um processo (**pai**) pode criar outros (**filhos**), formando uma **árvore de processos**. Cada processo tem um identificador único, o **PID** — por exemplo, `init` (PID 1) é o pai de todos.

- **Recursos do filho:** obtidos diretamente do S.O ou de um subconjunto dos recursos do pai (o que evita sobrecarga). O pai também pode passar **dados de entrada** ao filho.
- **Execução:** o pai continua executando concorrentemente com os filhos, **ou** espera que alguns ou todos terminem.
- **Espaço de endereçamento:** o filho é uma **duplicata do pai** (`fork()` no Unix) **ou** carrega um **novo programa** (`exec()`).

**Encerramento.** O processo termina com `exit()`, pode devolver um **status** ao pai via `wait()`, e todos os seus recursos são liberados. Um pai pode encerrar um filho que excedeu recursos, cuja tarefa não é mais necessária, ou quando o próprio pai termina (**encerramento em cascata**). No Windows, um processo pode encerrar outro com `TerminateProcess()`.

| Situação | O que acontece |
|---|---|
| **Processo zumbi** | O filho terminou, mas o pai ainda não chamou `wait()`; sua entrada na tabela de processos permanece. |
| **Processo órfão** | O pai terminou sem chamar `wait()`. No Linux e UNIX, o `init` adota o órfão e chama `wait()` periodicamente. |

### Parte V · Comunicação interprocessos (IPC)

<span class="slides-ref">[Slides 85–115](../arquivos/unidade-3.pdf#page=85){ target="_blank" }</span>

Razões para permitir a cooperação entre processos: **modularidade** (ex.: um player que separa a decodificação do áudio da renderização da imagem) e **conveniência** (várias tarefas ao mesmo tempo).

!!! example "Estudo de caso: arquitetura multiprocessos do Chrome"
    Em um navegador de processo único, se uma aba trava, todas caem. O Chrome usa três tipos de processo:

    - **Navegador** — interface, E/S de disco e rede (um só).
    - **Renderizador** — HTML, JavaScript, CSS; em geral um por site aberto, executando em uma **sandbox**.
    - **Plug-in** — um para cada tipo de plug-in.

    Se um site falha, só o seu renderizador é afetado.

**Processos cooperativos** podem afetar ou ser afetados por outros e precisam de um mecanismo de IPC. Há dois modelos, que costumam coexistir:

| | Memória compartilhada | Transmissão de mensagens |
|---|---|---|
| Como funciona | Uma região de memória comum, lida e gravada pelos processos | Mensagens trocadas por meio do S.O |
| Vantagem | Mais rápida: evita chamadas de sistema a cada troca | Boa para pequenas quantidades de dados; mais fácil em sistemas distribuídos |
| Exemplo dos slides | Produtor-consumidor com **buffer**: no YouTube, a rede baixa o vídeo e o player lê do buffer | Aplicativos de chat; operações `send(message)` e `receive(message)` |

Os slides observam que, em sistemas multicore, pesquisas indicam melhor desempenho geral da transmissão de mensagens.

**Detalhes da transmissão de mensagens:**

- **Comunicação direta:** cada processo nomeia o outro — `send(P, message)`, `receive(Q, message)`.
- **Comunicação indireta:** por **caixas postais** (*ports*) — `send(A, message)`, `receive(A, message)`. Um link pode envolver mais de dois processos. A caixa pode pertencer ao **processo** (some quando ele termina) ou ao **S.O** (independente).
- **Sincronização:** envio e recebimento podem ser **com bloqueio** (síncronos) ou **sem bloqueio** (assíncronos).
- **Buffer:** capacidade **zero** (o emissor espera o receptor), **limitada** (bloqueia quando a fila enche) ou **ilimitada** (nunca bloqueia).

## Para pensar

!!! question "Perguntas propostas nos slides"
    1. **Slide 8:** os primeiros computadores executavam apenas um programa por vez, com controle total do sistema. **Qual o problema desse cenário?**
    2. **Slides 109–110:** P1, P2 e P3 compartilham a caixa postal A. P1 envia uma mensagem e P2 e P3 executam `receive()` em A. **Qual processo recebe a mensagem?** *(A resposta, "Depende!", e as três soluções possíveis estão no slide 110.)*
