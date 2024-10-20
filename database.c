#include <stdio.h>
#include <stdlib.h>
#include "database.h"

database create_empty_database(int n){
    database db = malloc(sizeof(struct database_s));
    db->size = n;
    db->datas = malloc(n * sizeof(struct classified_data_s));
    return db;
}

void delete_database(database db){
    for(int i = 0; i < db->size; i++){
        delete_vector(db->datas[i].vector);
    }
    free(db->datas);
    free(db);
}

void print_database(database db){
    printf("{\n");

    for(int i = 0; i < db->size; i++){
        printf("  ");
        print_vector(db->datas[i].vector);
        printf("~>");
        printf("%d", db->datas[i].classe);
        printf("\n");
    }
    printf("}\n");
}
