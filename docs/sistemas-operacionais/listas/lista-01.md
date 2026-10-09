# Lista 01 · Processos

!!! info "Entrega"
    **Prazo:** [dd/mm/aaaa, 23h59] · **Valor:** [x pontos] · **Como entregar:** [ex.: GitHub Classroom, SIGAA, e-mail]

    Entregue um único `.pdf` com as respostas teóricas e os arquivos `.c` das questões práticas.

**Conteúdo:** [Aula 01](../aulas/01-introducao.md) e [Aula 02](../aulas/02-processos.md).

## Parte A — Teoria

**1.** Explique a diferença entre programa e processo. Dê um exemplo em que um mesmo programa gera vários processos.

**2.** Desenhe o diagrama de estados de um processo e explique uma situação concreta que provoca cada transição.

**3.** O que é o PCB? Por que ele é essencial para a troca de contexto?

**4.** Explique o que são processos **zumbis** e **órfãos**. Qual deles pode ser um problema se acumular, e por quê?

## Parte B — Análise de código

**5.** Quantos processos são criados (contando o original) e quantas vezes "X" é impresso? Desenhe a árvore de processos.

```c
int main(void) {
    for (int i = 0; i < 3; i++) {
        fork();
    }
    printf("X\n");
    return 0;
}
```

**6.** Quais valores de `x` são impressos? Justifique.

```c
int main(void) {
    int x = 1;
    if (fork() == 0) {
        x = x * 10;
        printf("%d\n", x);
    } else {
        wait(NULL);
        x = x + 1;
        printf("%d\n", x);
    }
    return 0;
}
```

## Parte C — Prática

**7.** Escreva `cadeia.c`: o processo original cria um filho, que cria um neto, que cria um bisneto (uma "cadeia" de 4 processos). Cada um deve imprimir seu PID e o PID do pai. O processo original só pode terminar depois de todos os descendentes.

**8.** Escreva `mini_shell.c`: um laço que lê um comando do teclado (sem argumentos, ex.: `ls`, `date`, `pwd`), cria um filho que o executa com `execlp()`, e espera ele terminar antes de ler o próximo. O programa termina quando o usuário digitar `sair`.

??? tip "Dicas para a questão 8"
    - Use `fgets()` para ler a linha e remova o `\n` do final.
    - Use `strcmp()` para comparar com `"sair"`.
    - Lembre-se de tratar o caso em que o `exec` falha (comando inexistente).
