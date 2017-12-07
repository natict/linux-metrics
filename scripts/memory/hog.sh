#!/bin/bash

HOG_C=/tmp/hog.c
HOG=/tmp/hog
rm -rf $HOG $HOG_C

cat >$HOG_C <<'EOF'
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>


int main(int argc, char* argv[]) {
    long page_size = sysconf(_SC_PAGESIZE);

    long count = 0;
    while(1) {
        char* tmp = (char*) malloc(page_size);
        if (tmp) {
            tmp[0] = 0;
            count += page_size;
            if (count % (page_size*1024) == 0) {
                printf("Allocated %ld KB\n", count/1024);
                usleep(10000);
            }
        }
    }

    return 0;
}
EOF

gcc -o $HOG $HOG_C

exec $HOG
