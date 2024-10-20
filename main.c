#include "database.h"
#include "vector.h"
#include "chained_list.h"

candidats pproche(database data, int k, vector input){
    candidats c = create_list(0, distance(data->datas[0].vector, input));
    int r = 1;
    for(int i = 1; i < data->size; i++){
        r = insertion_list(&c, r, k, data, i, input);
    }

    int* indices = malloc(k * sizeof(int));
    candidats tmp = c;
    // une boucle for suffit, car on a la condition  qu'il y a au moins k éléments dans la base, soit c est une liste de k élément
    for(int i = 0; i < k; i++){
        indices[i] = tmp->indice;
        tmp = tmp->next;
    }
    return indices;
}


// MAIN
int main(void){
    vector d = create_zero_vector(10);
    print_vector(d);
    delete_vector(d);
    return 0;
}