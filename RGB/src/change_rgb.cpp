#include <iostream>
#include "bmp.h"
using namespace std;

void change_rgb(int (&R)[MaxBMPSizeX][MaxBMPSizeY], int (&G)[MaxBMPSizeX][MaxBMPSizeY], int (&B)[MaxBMPSizeX][MaxBMPSizeY],
           int (&r)[MaxBMPSizeX][MaxBMPSizeY], int (&g)[MaxBMPSizeX][MaxBMPSizeY], int (&b)[MaxBMPSizeX][MaxBMPSizeY],
           int width,int height,int (&rgb_offest)[3]){
    // change color on image data
     for(int i=0;i<height;i++){
       for(int j=0;j<width;j++){
         if(rgb_offest[1] == 0 && rgb_offest[2] == 0 ){
           r[i][j] = rgb_offest[0];
           g[i][j] = G[i][j] + rgb_offest[1];
           b[i][j] = B[i][j] + rgb_offest[2];
         }
         else if(rgb_offest[0] == 0 && rgb_offest[1] == 0 ){
           r[i][j] = R[i][j] + rgb_offest[0];
           g[i][j] = G[i][j] + rgb_offest[1];
           b[i][j] = rgb_offest[2];
         }
         else if(rgb_offest[0] == 0 && rgb_offest[2] == 0 ){
           r[i][j] = R[i][j] + rgb_offest[0];
           g[i][j] = rgb_offest[1];
           b[i][j] = B[i][j] + rgb_offest[2];
         }
         else{
           r[i][j] = R[i][j] + rgb_offest[0];
           g[i][j] = G[i][j] + rgb_offest[1];
           b[i][j] = B[i][j] + rgb_offest[2];
         }
     }
   }
}
