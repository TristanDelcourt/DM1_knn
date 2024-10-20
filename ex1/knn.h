#pragma once
#include "vector.h"
#include "database.h"
#include "candidats.h"


extern int nb_classe_max;

candidats pproche(database data, int k, vector input);
int classe_majoritaire(database db, candidats lc, int r);
int classify(database db, int k, vector input);