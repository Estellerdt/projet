#include<stdio.h>
#include<stdlib.h>
#include"header.h"


pArbre creerNoeud(int a){
	pArbre noeud = malloc(sizeof(Arbre));
	if(noeud==NULL){
		exit(1);
	}
	noeud->elmt=a;
	noeud->fg=NULL;
	noeud->fd=NULL;
	return noeud;
}

	
void insertABR(pArbre a, double e)
{
	if (e < a->elmt)
	{
		if (a->fg == NULL)
		{
			a->fg = creerNoeud(e);
		}
		else
			insertABR(a->fg, e);
	}
	else if (e > a->elmt)
	{
		if (a->fd == NULL)
		{
			a->fd = creerNoeud(e);
		}
		else
			insertABR(a->fd, e);
	}
}


pArbre tri_ABR_croissant(double *tab, int nbligne) // tri ABR croissant
{
	int i;
	pArbre arbre = creerNoeud(tab[0]);
	for (i = 1; i < nbligne; i++)
	{
		insertABR(arbre, tab[i]);
	}
	return arbre;
}

void affiche_ABR_decroissant(pArbre a)
{
    if (a->fd == NULL)	
	{
		printf("%lf\n", a->elmt); 	// si le fd n'existe pas afficher son element
	}
	if (a->fd != NULL)
	{
		affiche_ABR_decroissant(a->fd);
		printf("%lf\n", a->elmt);	//
	}
	if (a->fg != NULL)
	{
		affiche_ABR_decroissant(a->fg);
	}
}



void affiche_ABR(pArbre a)
{
	if (a->fg == NULL)
	{
		printf("%lf\n", a->elmt);
	}
	if (a->fg != NULL)
	{
		affiche_ABR(a->fg);
		printf("%lf\n", a->elmt);
	}
	if (a->fd != NULL)
	{
		affiche_ABR(a->fd);
	}
}
