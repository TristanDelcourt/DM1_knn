#include "knn.h"
#include <stdlib.h>
int nb_classe_max;

candidats pproche(database data, int k, vector input){
    candidats c = create_list(0, distance(data->datas[0].vector, input));
    int r = 1;
    for(int i = 1; i < data->size; i++){
        r = insertion_list(&c, r, k, data, i, input);
    }

    /* 
    
    D'après les question suivantes, la liste elle-même doit etre renvoyé,
    mais la spécifications demandé est celle avec la code suivant

    int* indices = malloc(k * sizeof(int));
    candidats tmp = c;
    // une boucle for suffit, car on a la condition qu'il y a au moins k éléments dans la base, soit c est une liste de k élément
    for(int i = 0; i < k; i++){
        indices[i] = tmp->indice;
        tmp = tmp->next;
    }
    return indices;
    */

    return c;
}


int classe_majoritaire(database db, candidats lc, int r){
    int* occ = malloc(nb_classe_max * sizeof(int));

    for(int i = 0; i<nb_classe_max; i++)
        occ[i] = 0;

    candidats c = lc;
    for(int i = 0; i<r; i++){
        occ[db->datas[c->indice].classe] ++;
        c = c->next;
    }

    int i_max = 0;
    int max = 0;
    for(int i = 0; i<nb_classe_max; i++){
        if(occ[i] > max){
            max = occ[i];
            i_max = i; 
        }
    }

    return i_max;
}

int classify(database db, int k, vector input){
    candidats lc = pproche(db, k, input);
    return classe_majoritaire(db, lc, k);
}