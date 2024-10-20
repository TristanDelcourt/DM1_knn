#include "lecture_mnist.h"
#include "knn.h"
#include <stdio.h>
#include <stdlib.h>

int** matrix(int n, int m){
    int** mat = malloc(m * sizeof(int*));
    for(int i = 0; i<m; i++){
        mat[i] = malloc(n * sizeof(int));
        for(int j = 0; j<n; j++){
            mat[i][j] = 0;
        }
    }
    return mat;
}

void print_matric(int** m){
    for(int i = 0; i<10; i++){
        for(int j = 0; j<10; j++){
            printf("%d ", m[i][j]);
        }
        printf("\n");
    }
}

void free_matrix(int** m){
    for(int i = 0; i<10; i++){
        free(m[i]);
    }
    free(m);
}

// MAIN
int main(void){
    nb_classe_max = 10;
    database learn_db = create_empty_database(10000);
    database test_db = create_empty_database(1000);
    mnist_input(10000, &learn_db, 1000, &test_db);
    int** m = matrix(nb_classe_max, nb_classe_max);
    for(int i = 0; i<1000; i++){
        int c = classify(learn_db, 3, test_db->datas[i].vector);
        m[c][test_db->datas[i].classe]++;
    }
    print_matric(m);
    free_matrix(m);
}


/*
int main(void){
    nb_classe_max = 4;
    database db = fabrique_jeu_donnees(500);

    vector v = create_zero_vector(2);
    v->content[0] = 220;
    v->content[1] = 160;
    printf("%d\n", classify(db, 3, v));

    //print_database(db);
    delete_vector(v);
    delete_database(db);
    return 0;
}
*/