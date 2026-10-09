CC     = gcc
CFLAGS = -Wall -Wextra -g
PROGS  = 01_fork 02_wait 03_exec

all: $(PROGS)

%: %.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(PROGS)

.PHONY: all clean
