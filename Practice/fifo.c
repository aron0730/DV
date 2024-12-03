#include <stdio.h>
#include <stdlib.h>

#define FIFO_SIZE (4096 / 4)

typedef struct {
    int val[FIFO_SIZE];
    int head;
    int tail;
} FIFO;

void initFIFO(FIFO *fifo) {
    fifo->head = 0;
    fifo->tail = 0;
}

int isFull(FIFO *fifo) {
    return ((fifo->tail + 1) % FIFO_SIZE) == fifo->head;
}

int isEmpty(FIFO *fifo) {
    return fifo->head == fifo->tail;
}

int dequeue(FIFO *fifo) {
    if (isEmpty(fifo)) {
        printf("FIFO is empty!\n");
        return -1;
    }

    int val = fifo->val[fifo->head];
    fifo->head = (fifo->head + 1) % FIFO_SIZE;
    return val;
}

void enqueue(FIFO *fifo, int value) {
    if (isFull(fifo)) {
        printf("FIFO is full!\n");
        return -1;
    }

    fifo->val[fifo->tail] = value;
    fifo->tail = (fifo->tail + 1) % FIFO_SIZE;
}

