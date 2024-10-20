#include "vector.h"
#include "database.h"
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int quadrant(vector v){
    assert(v->taille == 2);
    return (v->content[0] > 127) + 2 * (v->content[1] > 127);
}

database fabrique_jeu_donnees(int db_size){
    srand(time(NULL));
    database db = create_empty_database(db_size);

    for(int i = 0; i<db_size; i++){
        vector v = create_zero_vector(2);
        v->content[0] = random() % 256;
        v->content[1] = random() % 256;

        classified_data d;
        d.vector = v;
        d.classe = quadrant(v);
        
        db->datas[i] = d;
    }

    return db;
}
