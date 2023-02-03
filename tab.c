#include<stdio.h>
#include<stdlib.h>
#include"header.h"



void swap(double* xp, double* yp)
{
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}

void tri_bulle_croissant(double *tab, int nbligne) // tri croissant 
{
    int i, j;
    for (i = 0; i < nbligne - 1; i++)

    for (j = 0; j < nbligne - i - 1; j++)
        if (tab[j] > tab[j + 1])
            swap(&tab[j], &tab[j + 1]);
}
void tri_bulle_decroissant(double *tab, int nbligne) // tri decroissant 
{
    int i, j;
    for (i = 0; i < nbligne - 1; i++)

    for (j = 0; j < nbligne - i - 1; j++)
        if (tab[j] < tab[j + 1])
            swap(&tab[j], &tab[j + 1]);
}


void print_tab(char **tab) { // affiche le tableau de chaines de caractères
    int i = 0;

    while (tab[i] != NULL && i < 11) {
        printf(" %s\n", tab[i]);
        i++;
    }
} 
