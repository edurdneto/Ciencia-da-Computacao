/*
 * Aula 02 — Processos
 * Exemplo 2: o pai espera o filho terminar com waitpid() e lê o código de saída.
 *
 * Compile: gcc -Wall -o 02_wait 02_wait.c
 * Execute: ./02_wait
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(void) {
    pid_t pid = fork();

    if (pid < 0) {
        perror("fork");
        exit(EXIT_FAILURE);
    }

    if (pid == 0) {
        printf("[filho] trabalhando por 2 segundos...\n");
        sleep(2);
        printf("[filho] terminei.\n");
        exit(42); /* código de saída que o pai vai ler */
    }

    int status;
    printf("[pai] aguardando o filho %d...\n", pid);
    if (waitpid(pid, &status, 0) < 0) {
        perror("waitpid");
        exit(EXIT_FAILURE);
    }

    if (WIFEXITED(status)) {
        printf("[pai] filho terminou com código %d\n", WEXITSTATUS(status));
    }
    return 0;
}
