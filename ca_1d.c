#include <stdio.h>
#include <unistd.h>

int main() {
   // printf() displays the string inside quotation
   
    const int length = 90;
    int iterations = 850;
    int cellsA[length] = {0};
    cellsA[length / 2] = 1;
    int cellsB[length];
    int *curCells = cellsB;
    int *oldCells = cellsA;
    for (int i = 0; i < iterations; i++) {
      for (int c = 0; c < length; c++) {
        int sum = 0;
        sum += (c-1) < 0 ? 0 : oldCells[c-1];
        sum += oldCells[c];
        sum += (c+1) < length ? oldCells[c+1] : 0;
        if (oldCells[c] == 0) {
            printf(" ");
        } else { 
            printf("0");
        }
        if (sum == 1) {
            curCells[c] = 1;
        } else {
            curCells[c] = 0;
        }
      }
      printf("\n");
      sleep(1);
      int *temp = curCells;
      curCells = oldCells;
      oldCells = temp;
    }
    // printf("Hello, World! Num: %d\n", x);
    return 0;
}

