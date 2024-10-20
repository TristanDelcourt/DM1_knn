#pragma once
#include "vector.h"
#include "database.h"

typedef struct s_cellule* candidats;
struct s_cellule {
    int indice ;      /* indice du point dans le jeu de données */
    double distance ; /* distance au point de recherche */
    candidats next;
};

// Crée une liste de candidats contenant un seul élément
candidats create_list(int ind, double dist);

// Libère la mémoire allouée pour la liste de candidats c
void delete_list(candidats c);

// Affiche la liste de candidats c
void print_list(candidats c);

/* Insère le point i dans la liste de candidats pl, en respectant:
 - l'ordre décroissant des distances
 - un nombre maximale d'élément k
et renvoie le nombre d'éléments dans la liste après insertion
*/
int insertion_list(candidats* pl, int r, int k, database db, int i, vector input);