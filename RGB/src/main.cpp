#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <typeinfo>
#include "bmp.h"
#define _RGB_VALUE_CHANGE_  "RGB"
using namespace std;

//const char* _RGB_VALUE_CHANGE_ = "RGB";
int R[MaxBMPSizeX][MaxBMPSizeY];
int G[MaxBMPSizeX][MaxBMPSizeY];
int B[MaxBMPSizeX][MaxBMPSizeY];
int r[MaxBMPSizeX][MaxBMPSizeY]={0};
int g[MaxBMPSizeX][MaxBMPSizeY]={0};
int b[MaxBMPSizeX][MaxBMPSizeY]={0};
int rgb_offest[3]={0,0,0};
extern void edge_detector(int (&R)[MaxBMPSizeX][MaxBMPSizeY],int (&G)[MaxBMPSizeX][MaxBMPSizeY],int (&B)[MaxBMPSizeX][MaxBMPSizeY],int (&r)[MaxBMPSizeX][MaxBMPSizeY],int (&g)[MaxBMPSizeX][MaxBMPSizeY],int (&b)[MaxBMPSizeX][MaxBMPSizeY], int width,int height);
extern void change_rgb(int (&R)[MaxBMPSizeX][MaxBMPSizeY], int (&G)[MaxBMPSizeX][MaxBMPSizeY], int (&B)[MaxBMPSizeX][MaxBMPSizeY],
                       int (&r)[MaxBMPSizeX][MaxBMPSizeY], int (&g)[MaxBMPSizeX][MaxBMPSizeY], int (&b)[MaxBMPSizeX][MaxBMPSizeY],
                       int width,int height,int (&rgb_offest)[3]);

int main(int argc,char* argv[])
{
    // arg process
    char* name = NULL; // store imag name
    char* outputname = NULL;
    //char *functionality = NULL; // progamming mode select
    char s[20]; //sscanf s parament
    if (argc < 3){
        cout<<"commad format error!"<<endl;
        cout<<"./Hough 'img path & img' 'output img name' "<<endl;
        return 0;
    }
    else if (argc == 3){
        name = argv[1];
        outputname = argv[2];
    }
    else if (argc == 4){
        name = argv[1];
        outputname = argv[2];
        cout<<argv[3]<<endl;
        cout<<typeid(argv[3]).name()<<endl;
        const char *functionality = argv[3];
        cout<<typeid(functionality).name()<<endl;
        if (strcmp(functionality,_RGB_VALUE_CHANGE_) == 0){
          cout<<"Input RGB Value: "<<"\neg. (10,30,20)"<<endl; // hint input format
          cin>>s; //get the string
          if(strlen(s) > 13){ //check the string s has correct
            cout<<s<<"format is not correct"<<endl;
            cout<<"eg. (r,g,b) rgb value range :0~255"<<endl;
            exit(0);
          }
          if (3 != sscanf(s, "(%d,%d,%d)", &rgb_offest[0],&rgb_offest[1],&rgb_offest[2])){ //check the rgb_offest have get correct value
            cout<<s<<"format is not correct"<<endl;
            exit(0);
          }

          int width,height;
          // open bmp
          open_bmp(name,R,G,B,width,height);
          change_rgb(R,G,B,r,g,b,width,height,rgb_offest);
          //edge_detector(R,G,B,r,g,b,width,height);
          save_bmp(outputname,r,g,b);
          cout<<"Job Finish"<<endl;

        }
        else{// user can add new else if statement to examine more function keyword
          cout<<"This Programming just have 1 function( changergb ) haha!!!"<<endl;
          exit(0);
        }
    }
    //cout<<"argc:"<<argc<<endl;
    //cout<<"argv[0]:"<<argv[0]<<" argv[1]:"<<argv[1]<<endl;
    //=============//

    return 0;
}
