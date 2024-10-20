#include "vector.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>

vector create_zero_vector(int n){
    vector v = malloc(sizeof(struct vector_s));
    v->taille = n;
    v->content = (unsigned char*)malloc(n * sizeof(unsigned char));
    for(int i = 0; i < n; i++){
        v->content[i] = 0;
    }
    return v;
}

void delete_vector(vector v){
    free(v->content);
    free(v);
}

void print_vector(vector v){
    printf("(");
    for(int i = 0; i < v->taille; i++){
        printf("%d", v->content[i]);
        if(i < v->taille - 1){
            printf(", ");
        }
    }
    printf(")\n");
}

double distance(vector u, vector v){
    assert(v->taille == v->taille);

    double sum = 0;
    for(int i = 0; i < v->taille; i++){
        sum += (u->content[i] - v->content[i]) * (u->content[i] - v->content[i]);
    }

    return sqrt(sum);
}