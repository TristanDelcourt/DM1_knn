#include <stdio.h>
#include <stdlib.h>
#include "candidats.h"
#include "vector.h"
#include "database.h"

candidats create_list(int ind, double dist){
    candidats c = malloc(sizeof(struct s_cellule));
    c->indice = ind;
    c->distance = dist;
    c->next = NULL;
    return c;
}

void delete_list(candidats c){
    candidats tmp;
    while(c != NULL){
        tmp = c;
        c = c->next;
        free(tmp);
    }
}

void print_list(candidats c){
    printf("[");
    while(c != NULL){
        printf("(%d, %f)", c->indice, c->distance);
        c = c->next;
        if(c != NULL){
            printf(", ");
        }
    }
    printf("]\n");
}

int insertion_list(candidats* pl, int r, int k, database db, int i, vector input){
    double dist = distance(db->datas[i].vector, input);

    // Trivial
    if (r == k &&  dist > (*pl)->distance){
        return k;
    }

    candidats next_ = *pl;
    candidats prev_ = NULL;
    while(next_ != NULL && dist < next_->distance){
        prev_ = next_;
        next_ = next_->next;
    }
    
    candidats c = create_list(i, dist);

    // insertion au début, r<k, le cas trivial étant géré au début de la fonction
    if(prev_ == NULL){
        c->next = (*pl);
        *pl = c;
        return r+1;
    }

    // insertion a la fin
    if(next_ == NULL){
        prev_->next = c;
    }

    // insertion au milieu de la liste
    else{
        c->next = next_;
        prev_->next = c;
    }

    // suppression éventuelle d'un élément
    if(r<k){
        return r+1;
    }
    else{
        candidats tmp = *pl;
        *pl = tmp->next;
        delete_list(tmp);
        return k;
    }

}