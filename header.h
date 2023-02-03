
typedef struct arbre{
	double elmt;
	struct arbre *fg;
	struct arbre *fd;
}Arbre;


typedef Arbre *pArbre;


pArbre tri_ABR_croissant(double *tab, int nbligne);
void affiche_ABR(pArbre a);
void affiche_ABR_decroissant(pArbre a);

void tri_bulle_croissant(double *tab, int nbligne);
void tri_bulle_decroissant(double *tab, int nbligne);
