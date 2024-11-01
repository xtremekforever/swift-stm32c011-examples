
#include <stddef.h>

extern int main(int argc, char *argv[]);

void reset(void) {
    main(0, NULL);
}

void interrupt(void) {
    while (1) {}
}

__attribute((used)) __attribute((section("__VECTORS,__text")))
void *vector_table[48] = {
    (void *)0x20001800, // initial SP
    reset, // Reset

    interrupt, // NMI
    interrupt, // HardFault
    
    0 // NULL for all the other handlers
};
