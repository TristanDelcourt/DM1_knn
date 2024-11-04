#pragma once
#include "vector.h"
#include "database.h"

// Donne la classe du vecteur v en fonction de ses coordonnées
int quadrant(vector v);

// Crée une base de données de taille db_size contenant des vecteurs de taille 2 entre (0, 0) et (255, 255) avec leur classe
database fabrique_jeu_donnees(int db_size);