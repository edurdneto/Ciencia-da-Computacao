/*
 * Aula 02 — Processos
 * Exemplo 3: fork() + exec() — o filho passa a executar outro programa (ls -l).
 * É assim que o shell executa os comandos que você digita.
 *
 * Compile: gcc -Wall -o 03_exec 03_exec.c
 * Execute: ./03_exec
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
        char *args[] = {"ls", "-l", NULL};
        execvp(args[0], args);
        /* Só chega aqui se o exec falhar */
        perror("execvp");
        exit(EXIT_FAILURE);
    }

    waitpid(pid, NULL, 0);
    printf("[pai] o comando 'ls -l' terminou.\n");
    return 0;
}
