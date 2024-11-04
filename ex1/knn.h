#pragma once
#include "vector.h"
#include "database.h"
#include "candidats.h"


extern int nb_classe_max;

/*
prend en arguments un jeu de données db, un entier k tel que db->size > k et un vecteur input, et retournant la liste des candidats dans db->datas des k plus proches vecteurs de input (parmi
ceux de db->datas)
*/
candidats pproche(database data, int k, vector input);

/*
prend en arguments une liste de candidats lc de taille r et retournant la classe la plus présente
parmi les r données classifiées dans db repérées par leur indice dans lc.
*/
int classe_majoritaire(database db, candidats lc, int r);

/*
prenant
en arguments un jeu de données data, la taille du jeu data_size, un entier k tel que db->size >
k et un vecteur input, et retournant la classe la plus présente parmi les k plus proches voisins
de input.
*/
int classify(database db, int k, vector input);