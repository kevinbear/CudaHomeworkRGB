#include "bmp.h"
#include <math.h>
#include <iostream>
using namespace std;
void edge_detector(int (&R)[MaxBMPSizeX][MaxBMPSizeY],int (&G)[MaxBMPSizeX][MaxBMPSizeY],int (&B)[MaxBMPSizeX][MaxBMPSizeY],int (&r)[MaxBMPSizeX][MaxBMPSizeY],int (&g)[MaxBMPSizeX][MaxBMPSizeY],int (&b)[MaxBMPSizeX][MaxBMPSizeY], int width,int height)
{
    int filter_x[3][3] = {{1,0,-1},{2,0,-2},{1,0,-1}};
    int filter_y[3][3] = {{1,2,1},{0,0,0},{-1,-2,-1}};
    float temp_r=0,temp_g=0,temp_b=0;
    for(int i=1;i<height-1;i++)
    {
        for(int j=1;j<width-1;j++)
        {
            for(int y=-1;y<2;y++)
            {
                for(int x=-1;x<2;x++)
                {
                    temp_r += R[i+y][j+x]*filter_x[y+1][x+1];
                    temp_g += G[i+y][j+x]*filter_x[y+1][x+1];
                    temp_b += B[i+y][j+x]*filter_x[y+1][x+1];
                }
            }
            r[i][j]=(int)(temp_r*temp_r);
            g[i][j]=(int)(temp_g*temp_g);
            b[i][j]=(int)(temp_b*temp_b);
//            cout<<"r: "<<r[i][j]<<"\n";
//            cout<<"g: "<<g[i][j]<<"\n";
//            cout<<"b: "<<b[i][j]<<"\n";
            temp_r=0;temp_g=0;temp_b=0;
        }
    }
    temp_r=0;temp_g=0;temp_b=0;//init again
    for(int i=1;i<height-1;i++)
    {
        for(int j=1;j<width-1;j++)
        {
            for(int y=-1;y<2;y++)
            {
                for(int x=-1;x<2;x++)
                {
                    temp_r += R[i+y][j+x]*filter_y[y+1][x+1];
                    temp_g += G[i+y][j+x]*filter_y[y+1][x+1];
                    temp_b += B[i+y][j+x]*filter_y[y+1][x+1];
                }
            }
            r[i][j] += (int)(temp_r*temp_r);
            g[i][j] += (int)(temp_g*temp_g);
            b[i][j] += (int)(temp_b*temp_b);
//            cout<<"r: "<<r[i][j]<<"\n";
//            cout<<"g: "<<g[i][j]<<"\n";
//            cout<<"b: "<<b[i][j]<<"\n";
            r[i][j] = sqrt(r[i][j]) >100 ? 255 :0;
            g[i][j] = sqrt(g[i][j]) >100 ? 255 :0;
            b[i][j] = sqrt(b[i][j]) >100 ? 255 :0;
//            cout<<"r: "<<r[i][j]<<"\n";
//            cout<<"g: "<<g[i][j]<<"\n";
//            cout<<"b: "<<b[i][j]<<"\n";
            temp_r=0;temp_g=0;temp_b=0;
        }
    }
}
