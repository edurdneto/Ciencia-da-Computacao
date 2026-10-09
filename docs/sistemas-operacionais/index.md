# Sistemas Operacionais

!!! info "Informações da turma"
    **Semestre:** [2026.2] · **Horário:** [dias e horários] · **Sala:** [sala/laboratório]
    **Carga horária:** [64 h] · **Pré-requisitos:** Programação em C, Arquitetura de Computadores

## Ementa

Conceitos e estrutura de sistemas operacionais. Processos e threads. Comunicação entre processos. Escalonamento de CPU. Sincronização e problemas clássicos. Deadlocks. Gerência de memória e memória virtual. Sistemas de arquivos. Entrada e saída. Noções de virtualização e segurança.

## Objetivos

Ao final da disciplina, você será capaz de:

- [x] Explicar o papel do sistema operacional e como ele se relaciona com o hardware e os programas.
- [x] Criar e gerenciar processos e threads em C usando as chamadas de sistema POSIX.
- [x] Comparar algoritmos de escalonamento e calcular métricas como tempo de espera e de retorno.
- [x] Identificar condições de corrida e resolvê-las com mutexes, semáforos e variáveis de condição.
- [x] Detectar, prevenir e evitar deadlocks.
- [x] Descrever paginação, segmentação e algoritmos de substituição de páginas.
- [x] Explicar a organização de sistemas de arquivos e dispositivos de E/S.

## Ambiente de prática

Usaremos **Linux** e a linguagem **C**. Você precisa de:

- `gcc` e `make` — no Ubuntu/Debian: `sudo apt install build-essential`
- Um editor (VS Code, Vim, etc.)

??? question "Uso Windows ou macOS. E agora?"
    - **Windows:** instale o [WSL 2](https://learn.microsoft.com/pt-br/windows/wsl/install) com Ubuntu. Funciona como um Linux de verdade.
    - **macOS:** a maioria dos exemplos funciona (instale as *Command Line Tools* com `xcode-select --install`), mas alguns detalhes mudam. Na dúvida, use uma máquina virtual Linux.
    - **Sem instalar nada:** use o [GitHub Codespaces](https://github.com/features/codespaces) no próprio repositório.

## Avaliação

| Avaliação | Peso | Conteúdo |
|---|---|---|
| Prova 1 (P1) | [30%] | Aulas 1 a 8 |
| Prova 2 (P2) | [30%] | Aulas 9 a 16 |
| Listas de exercícios | [20%] | Todas as listas |
| Trabalho prático | [20%] | Projeto em C (enunciado a divulgar) |

**Média final** = [fórmula]. [Regra de recuperação/exame final.]

## Bibliografia

**Básica**

- TANENBAUM, A. S.; BOS, H. *Sistemas Operacionais Modernos*. 4. ed. Pearson, 2016.
- SILBERSCHATZ, A.; GALVIN, P. B.; GAGNE, G. *Fundamentos de Sistemas Operacionais*. 9. ed. LTC, 2015.
- ARPACI-DUSSEAU, R. H.; ARPACI-DUSSEAU, A. C. *Operating Systems: Three Easy Pieces*. Disponível gratuitamente em [ostep.org](https://pages.cs.wisc.edu/~remzi/OSTEP/).

**Complementar**

- MACHADO, F. B.; MAIA, L. P. *Arquitetura de Sistemas Operacionais*. 5. ed. LTC, 2013.
- KERRISK, M. *The Linux Programming Interface*. No Starch Press, 2010.
