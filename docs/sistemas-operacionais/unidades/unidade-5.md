# Unidade 5 · Sincronização

<div class="resumo-aula" markdown>
[:material-presentation-play: Abrir os slides](../arquivos/unidade-5.pdf){ .md-button .md-button--primary target="_blank" }
[:material-download: Baixar PDF · 85 slides](../arquivos/unidade-5.pdf){ .md-button download }
[:material-arrow-right: Próxima: Scheduling da CPU](unidade-6.md){ .md-button }
</div>

!!! quote "Objetivo central"
    Coordenar a execução de múltiplos processos/threads concorrentes que compartilham recursos, **garantindo a consistência dos dados**.

    *Exemplo:* dois saques bancários simultâneos na mesma conta. Sem sincronização, ambos leem o mesmo saldo inicial e o cálculo sai errado — uma **condição de corrida**.

!!! abstract "Nesta unidade"
    1. **Recapitulação:** threads, concorrência × paralelismo e Lei de Amdahl
    2. **Antecedentes da sincronização** — produtor-consumidor e condição de corrida
    3. **O problema da seção crítica**
    4. **Solução de Peterson**
    5. **Semáforos e monitores**
    6. **Jantar dos filósofos**

## Slides

<div class="pdf-slides">
  <iframe src="../../arquivos/unidade-5.pdf#view=FitH" title="Slides da Unidade 5" loading="lazy"></iframe>
</div>

!!! tip "No celular os slides não aparecem?"
    Alguns navegadores de celular não exibem PDF dentro da página. Use o botão **Abrir os slides** acima.

## Resumo da unidade

### Recapitulação da Unidade 4

<span class="slides-ref">[Slides 3–6](../arquivos/unidade-5.pdf#page=3){ target="_blank" }</span>

- **Thread:** menor unidade de execução enviada à CPU, com ID, contador de programa, registradores e pilha próprios.
- **Concorrência** é lidar com várias coisas (um garçom atendendo várias mesas); **paralelismo** é fazer várias coisas ao mesmo tempo (dois garçons). É possível ter concorrência sem paralelismo.
- **Lei de Amdahl:** com 25% de código serial, 5 núcleos dão cerca de **2,5×**; o limite com infinitos núcleos é **4×**. A prioridade deve ser **diminuir a fração serial**.

### Parte I · Antecedentes da sincronização

<span class="slides-ref">[Slides 7–22](../arquivos/unidade-5.pdf#page=7){ target="_blank" }</span>

Um **processo cooperativo** pode afetar ou ser afetado por outros. Quando compartilham memória, o acesso simultâneo sem sincronização pode **corromper os dados**.

**Produtor-consumidor com buffer limitado.** O produtor insere itens no buffer e o consumidor os retira. Uma variável `counter` conta os itens: o produtor faz `counter++`, o consumidor faz `counter--`.

=== "Produtor"

    ```c
    while (true) {
        item = produzir_item();
        while (counter == BUFFER_SIZE)
            ; /* buffer cheio: espera ocupada */
        buffer[in] = item;
        in = (in + 1) % BUFFER_SIZE;
        counter++;
    }
    ```

=== "Consumidor"

    ```c
    while (true) {
        while (counter == 0)
            ; /* buffer vazio: espera ocupada */
        next_consumed = buffer[out];
        out = (out + 1) % BUFFER_SIZE;
        counter--;
        consome_item(next_consumed);
    }
    ```

Cada rotina está correta isoladamente, mas **juntas** podem dar resultado errado. Com `counter = 5`, após um `counter++` e um `counter--` concorrentes, o valor final pode ser **4, 5 ou 6**.

**Por quê?** `counter++` **não é atômico**. Em linguagem de máquina, vira três passos:

```text
registrador1 = counter          // 1. lê da RAM
registrador1 = registrador1 + 1 // 2. modifica na CPU
counter = registrador1          // 3. escreve na RAM
```

!!! example "Intercalação que produz o erro (slide 18)"
    | Tempo | Processo | Instrução | Resultado |
    |---|---|---|---|
    | T0 | Produtor | `reg1 = counter` | reg1 = 5 |
    | T1 | Produtor | `reg1 = reg1 + 1` | reg1 = 6 |
    | T2 | Consumidor | `reg2 = counter` | reg2 = 5 |
    | T3 | Consumidor | `reg2 = reg2 - 1` | reg2 = 4 |
    | T4 | Produtor | `counter = reg1` | counter = 6 |
    | T5 | Consumidor | `counter = reg2` | **counter = 4** ✗ |

    Há 5 itens no buffer, mas `counter` diz 4: a escrita do produtor foi sobrescrita. Invertendo T4 e T5, o resultado seria 6 — também errado. **Vale quem escreve por último.**

**Condição de corrida (*race condition*):** vários processos acessam e modificam os mesmos dados concorrentemente, e o resultado depende da **ordem** dos acessos. A solução é garantir que **apenas um processo por vez** altere a variável.

### Parte II · O problema da seção crítica

<span class="slides-ref">[Slides 23–31](../arquivos/unidade-5.pdf#page=23){ target="_blank" }</span>

A **seção crítica** é o trecho de código em que o processo manipula recursos compartilhados (variáveis globais, registros de banco, arquivos). **Regra de ouro:** enquanto um processo está na sua seção crítica, **nenhum outro** pode entrar na sua.

```c
do {
    /* seção de entrada  — pede permissão (adquirir a trava) */
    /* SEÇÃO CRÍTICA     — acesso exclusivo ao recurso       */
    /* seção de saída    — libera o recurso                  */
    /* seção remanescente — código local                     */
} while (true);
```

Uma solução válida precisa garantir **três requisitos**:

| Requisito | Regra | Analogia dos slides |
|---|---|---|
| **Exclusão mútua** | Se Pi está na seção crítica, nenhum outro processo está na sua. | Provador de roupas trancado por dentro |
| **Progresso** | Se a seção está livre, só quem quer entrar participa da decisão, e ela não pode ser adiada para sempre. | Sala de reunião: quem está em casa não opina |
| **Espera limitada** | Há um limite de vezes que outros entram antes de Pi, depois do pedido de Pi — evita **inanição**. | Senha no banco: com a #15, no máximo 14 são atendidos antes |

**No kernel:** uma lista global de arquivos abertos atualizada por dois processos ao mesmo tempo pode corromper ponteiros. Um **kernel com preempção** é mais responsivo, mas exige travas nos dados do kernel; um **kernel sem preempção** é mais seguro, mas um processo longo pode "congelar" o sistema.

### Parte III · Solução de Peterson

<span class="slides-ref">[Slides 33–45](../arquivos/unidade-5.pdf#page=33){ target="_blank" }</span>

Solução clássica **em software** para **dois processos** (P0 e P1), que compartilham:

- `int turn;` — de quem é a vez;
- `boolean flag[2];` — se cada processo quer entrar.

```c
do {
    flag[i] = true;               // 1. quero entrar
    turn = j;                     // 2. cedo a vez ao outro
    while (flag[j] && turn == j)
        ;                         //    espera ocupada
    /* SEÇÃO CRÍTICA */
    flag[i] = false;              // libera
    /* seção remanescente */
} while (true);
```

**Por que funciona:**

- **Exclusão mútua:** Pi só entra se `flag[j] == false` **ou** `turn == i`. Se os dois tentarem ao mesmo tempo, `turn` só guarda um valor (a última escrita prevalece), então só um avança.
- **Progresso:** o único ponto de espera é o `while`; quando Pj sai, faz `flag[j] = false`, liberando Pi.
- **Espera limitada:** Pi entra depois de **no máximo uma** entrada de Pj.

!!! warning "Desvantagens da solução de Peterson"
    - **Espera ocupada:** a CPU fica 100% ocupada testando o `while`.
    - **Só dois processos:** para N processos são necessárias extensões complexas, como a Padaria de Lamport.

!!! info "Sugestão de vídeo dos slides"
    [youtube.com/watch?v=_lh0FRox0OY](https://www.youtube.com/watch?v=_lh0FRox0OY)

### Parte IV · Semáforos

<span class="slides-ref">[Slides 46–65](../arquivos/unidade-5.pdf#page=46){ target="_blank" }</span>

Um **semáforo S** é uma variável inteira acessada (fora da inicialização) apenas por duas operações **atômicas**: `wait()` e `signal()`.

```c
wait(S) {               signal(S) {
    while (S <= 0)          S++;
        ;               }
    S--;
}
```

- **Semáforo binário (mutex):** valor 0 ou 1, garante exclusão mútua.
- **Semáforo contador:** controla o acesso a N instâncias de um recurso.

!!! example "Semáforo contador com N = 2 (slide 50)"
    | Passo | Operação | S | Efeito |
    |---|---|---|---|
    | 1 | P1 `wait()` | 1 | P1 recebe o recurso |
    | 2 | P2 `wait()` | 0 | P2 recebe o recurso |
    | 3 | P3 `wait()` | −1 | **P3 bloqueado** na fila |
    | 4 | P1 `signal()` | 0 | P3 acorda e assume o recurso |

**Sincronizar a ordem de execução:** para que S2 (em P2) só execute depois de S1 (em P1), use `synch = 0`: P1 faz `S1; signal(synch);` e P2 faz `wait(synch); S2;`.

**Implementação sem espera ocupada.** Em vez de ficar em loop, o processo se **bloqueia** e entra na fila do semáforo; o `signal()` o **acorda** e ele vai para a fila de prontos.

```c
typedef struct {
    int value;
    struct process *list;   // fila de processos bloqueados
} semaphore;

wait(semaphore *S) {
    S->value--;
    if (S->value < 0) {
        /* adiciona este processo a S->list */
        block();
    }
}

signal(semaphore *S) {
    S->value++;
    if (S->value <= 0) {
        /* remove um processo P de S->list */
        wakeup(P);
    }
}
```

Se `value = −K`, há exatamente **K processos** esperando. Uma fila **FIFO** garante espera limitada. A atomicidade de `wait()` e `signal()` é garantida, em um uniprocessador, **desabilitando interrupções**; em multiprocessadores, elas teriam de ser desabilitadas em todos os processadores.

**Deadlock e inanição.** Com dois semáforos S e Q (valor 1):

| P0 | P1 |
|---|---|
| `wait(S);` | `wait(Q);` |
| `wait(Q);` | `wait(S);` |
| ... | ... |
| `signal(S);` | `signal(Q);` |
| `signal(Q);` | `signal(S);` |

Se P0 executa `wait(S)` e P1 executa `wait(Q)`, cada um espera um `signal()` que só o outro pode fazer: **deadlock** (espera circular). **Inanição** é um processo esperar indefinidamente na fila do semáforo — por exemplo, com fila LIFO ou prioridades inadequadas.

### Parte V · Monitores

<span class="slides-ref">[Slides 66–75](../arquivos/unidade-5.pdf#page=66){ target="_blank" }</span>

Semáforos funcionam, mas o uso incorreto gera **erros de timing** difíceis de reproduzir:

- **Inverter** as operações (`signal()` antes, `wait()` depois): vários processos entram na seção crítica.
- Trocar `signal()` por `wait()` na saída: **deadlock** — o processo espera por si mesmo.
- **Esquecer** o `wait()`: a exclusão mútua é violada.

Basta **um** processo errado — por bug ou de propósito — para afetar todo o sistema.

Um **monitor** é um **tipo abstrato de dados** que encapsula variáveis compartilhadas, procedimentos e código de inicialização. **Só um processo por vez** executa dentro do monitor, e a exclusão mútua é garantida pelo **compilador**, não pelo programador. Exemplo em Java: métodos `synchronized`.

```text
monitor ContaBancaria {
    private double saldo;

    public deposito(valor) { saldo = saldo + valor; }
    public saque(valor)    { saldo = saldo - valor; }

    inicializacao() { saldo = 0.0; }
}
```

Se dois clientes sacarem ao mesmo tempo, o monitor bloqueia um até o outro terminar. Para sincronizações mais avançadas, monitores usam **variáveis de condição** com `wait()` e `signal()`.

### O jantar dos filósofos

<span class="slides-ref">[Slides 76–85](../arquivos/unidade-5.pdf#page=76){ target="_blank" }</span>

Problema clássico de Dijkstra: **5 filósofos** em uma mesa redonda, **5 garfos** (um entre cada par). Para comer, o filósofo precisa dos **dois** garfos vizinhos; ele alterna entre pensar e comer. Uma boa solução não pode ter **deadlock**, nem **inanição**, e deve permitir que filósofos não vizinhos comam ao mesmo tempo.

| Solução | Ideia | Problema |
|---|---|---|
| **1. Ingênua** | Pega o garfo da esquerda, depois o da direita | Se todos pegam o da esquerda ao mesmo tempo: **deadlock** |
| **2. Com liberação** | Se não conseguir o da direita, solta o da esquerda e espera 5 s | Se todos agem em sincronia, repetem para sempre: **livelock** |
| **3. Hierarquia de garfos** | Numera os garfos; todos pegam primeiro o de **menor índice** | **Livre de deadlock** — P5 pega G1 antes de G5, quebrando o ciclo |

```text
primeiro = min(esquerda, direita);
segundo  = max(esquerda, direita);
pegar_garfo(primeiro);
pegar_garfo(segundo);
comer(); liberar_garfos();
```

## Para pensar

!!! question "Exercício do slide 22 · Identificação de inconsistência"
    Três processos (P1, P2 e P3) executam `counter++` simultaneamente, sem sincronização, com `counter = 0`. Cada `counter++` é feito em três etapas: **read**, **increment** e **write**.

    1. Descreva **três** possíveis sequências de execução (ordem das leituras e escritas).
    2. Calcule o **valor final** de `counter` em cada sequência.
    3. Em cada uma, identifique qual(is) processo(s) teve(ram) sua atualização **sobrescrita**.

!!! question "Slide 84"
    Vocês podem propor uma solução **melhor** para o jantar dos filósofos?
