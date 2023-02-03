#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include"header.h"



void print_tab_chiffres(double *tab, int taille) { // affiche le tableau de type double
    int i = 0;

    while (i < taille) {
        printf("line %d: %lf\n", i, tab[i]);
        i++;
    }
} 

double * conversion( char** tab){ // convertit les char en double
    
    double * tab_chiffres = NULL; // creation tableau contenant des doubles
    char *ptr;
    int i = 0;
    while (tab[i] != NULL) { // parcourir le tableau
          if ((tab_chiffres = realloc(tab_chiffres , sizeof(double) * ( i + 1))) == NULL) { //  allouer la memoire et verifier pas d'erreur
                    exit(1);
                }
        tab_chiffres[i] = strtod(tab[i], &ptr); // echange du type
        i++;
    }
    return tab_chiffres;
}


void ecrire_fichier( double *tab, char *output_file, int taille ){ // creation fichier sortie
    FILE *fichier_sortie = fopen(output_file,"w+"); // ouverture du fichier et permission ecrire et vider le fichier 
    int i = 0;
     while (i < taille ) { // parcourir le tableau
        fprintf(fichier_sortie,"%lf\n",tab[i]); //ecrit dans le fichier les valeurs du tableau
        i++;
    }
    fclose(fichier_sortie);
}


void liberer_memoire(char **tab,double *tab_chiffres) {
    int i = 0;
    while(tab[i] != NULL){ // parcourir le tableau
        free(tab[i]);
        i++;
    }
    free(tab); // liberer le tableau
    free(tab_chiffres); //liberer le tableau
}

int mode = 0;
static struct option long_options[] =   //strcture qui affecte a tab-> mode=1...
        {
          {"tab",  0, &mode, 1},
          {"abr",  0, &mode, 2},
          {"avl",    0, &mode, 3},
          {0, 0, 0, 0}
        };


// argc: nombre de parametres
// argv: les parametres
int main(int argc, char **argv) {
    if (argc > 1 ){
        printf("Mes paramètres sont: %s\n", argv[1]); 

    char c; // variables qui prend les arguments pour le switch
    char est_option_f = 0;   // options fichier entrée
    char est_option_r = 0;  // option ordre decroissant
    char est_option_o = 0;   // option fichier sortie
    char *input_file;   // nom du fichier entrée
    char *output_file;   //nom fichier sortie
    int long_index = 0;
    while ((c = getopt_long(argc, argv, "ro:f:", long_options, &long_index)) != -1) {      // etude de tout les arguments 
        switch (c) {
            case 0 :

                break;
            case ('f'):
                est_option_f = 1;
                input_file = optarg; // comme f prend un argument getopt place un pointeur texte dans optarg
                printf("j'ai le paramètre f\n");
                break;
            case('o'):
                est_option_o = 1;
                output_file = optarg; // fichier de sortie
                printf("j'ai le parametre o\n");
                break;
            case('r'):
                est_option_r = 1;
                printf("j'ai le parametre r\n");
                break;
        }

    }
    if (!est_option_f || !est_option_o) { // verification des options obligatoire
        printf("Manque un parametre obligatoire\n");
        return (1); // erreur
    }
   
    printf("-f option: %s\n-o option: %s\n", input_file, output_file);
    FILE* fichier = NULL; // creation fichier
    char *ligne = NULL; 
    char **tab = NULL; // creation d'un tableau de chaine de caracteres
    int nbligne = 0;    // nb de ligne
    size_t taille = 0;  // taille du tableau
    ssize_t read;
    
    fichier = fopen(input_file, "r"); // ouverture du fichier inputfile et lecture
        if (fichier != NULL)     // si le fichier pas vide
        {
        // Boucle de lecture des caracteres un a un
           while ((read = getline(&ligne, &taille, fichier)) != -1) // tant qu'on arrive pas a la fin du fichier lecture du fichier et stockage dans 'ligne'
            {

                nbligne = nbligne +1; // incrémente le nbligne pour remplir le tab
                if ((tab = realloc(tab, sizeof(char *) * (nbligne + 1))) == NULL) { // verification pas erreur
                    return (1);
                }
                tab[nbligne - 1] = strdup(ligne); // copie les lignes du fichier dans le tableau
                tab[nbligne] = NULL;
            }
        double *tab_chiffres = conversion(tab); // recuperation du tableau de chaine de caractere en valeur numerique 
        
        if (!est_option_r){

            if ( mode == 1){
            tri_bulle_croissant(tab_chiffres, nbligne); // tri ordre croissant 
            print_tab_chiffres(tab_chiffres, nbligne);
             printf("Le mode de tri utilisé est un tableau\n");
            }
            if( mode == 2){
                pArbre arbre2 = tri_ABR_croissant(tab_chiffres,nbligne); 
                affiche_ABR(arbre2);
                printf("Le mode de tri utilisé est un ABR\n");
            }
        }
        else {
            if( mode == 1){
            tri_bulle_decroissant(tab_chiffres, nbligne);
            print_tab_chiffres(tab_chiffres, nbligne);
             printf("Le mode de tri utilisé est un tableau et décroissante\n");
            }
            if( mode == 2){
                 pArbre arbre2 = tri_ABR_croissant(tab_chiffres,nbligne); 
                 affiche_ABR_decroissant(arbre2);
            }
        }
        
        ecrire_fichier(tab_chiffres, output_file, nbligne);
        liberer_memoire(tab,tab_chiffres);
        }
    
    }
}

