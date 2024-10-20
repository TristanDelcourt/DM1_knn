#pragma once

#include "vector.h"

typedef struct classified_data_s {
    vector vector ; /* le vecteur */
    int classe;     /* sa classe */
} classified_data;

struct database_s {
    int size ;                        /* taille du jeu de données */
    classified_data* datas ; /* tableau des données classifiées */
};
typedef struct database_s* database;

// Crée une base de données vide de taille n
database create_empty_database(int n);

// Libère la mémoire allouée pour la base de données db
void delete_database(database db);

// Affiche la base de données db
void print_database(database db);