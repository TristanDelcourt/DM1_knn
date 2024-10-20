#pragma once

struct vector_s {
    int taille;             /* taille du tableau content */
    unsigned char* content; /* tableau d'éléments de [0, 255] */
};
typedef struct vector_s* vector;

// Crée un vecteur de taille n dont tous les éléments sont à 0
vector create_zero_vector(int n);

// Libère la mémoire allouée pour le vecteur v
void delete_vector(vector v);

// Affiche le vecteur v
void print_vector(vector v);

// Calcule la distance euclidienne entre deux vecteurs
double distance(vector u, vector v);