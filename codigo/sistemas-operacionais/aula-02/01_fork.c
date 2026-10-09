/*
 * Aula 02 — Processos
 * Exemplo 1: criando um processo filho com fork().
 *
 * Compile: gcc -Wall -o 01_fork 01_fork.c
 * Execute: ./01_fork
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main(void) {
    int x = 10;

    printf("Antes do fork: sou o processo %d\n", getpid());
    fflush(stdout); /* esvazia o buffer antes de duplicar o processo (veja a aula) */

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork");
        exit(EXIT_FAILURE);
    } else if (pid == 0) {
        /* Código executado apenas pelo FILHO */
        x = x + 5;
        printf("[filho] PID=%d, meu pai=%d, x=%d\n", getpid(), getppid(), x);
    } else {
        /* Código executado apenas pelo PAI */
        x = x - 5;
        printf("[pai]   PID=%d, meu filho=%d, x=%d\n", getpid(), pid, x);
    }

    /* Executado pelos DOIS processos */
    printf("Fim do processo %d (x=%d)\n", getpid(), x);
    return 0;
}
