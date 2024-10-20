#include "jeu_quadrant.h"
#include "knn.h"
#include <stdio.h>


// MAIN
int main(void){
    nb_classe_max = 4;
    database db = fabrique_jeu_donnees(50);

    vector v = create_zero_vector(2);
    v->content[0] = 64;
    v->content[1] = 65;
    printf("%d\n", classify(db, 1, v));

    //print_database(db);
    delete_database(db);
    return 0;
}