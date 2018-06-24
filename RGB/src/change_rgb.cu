#include <cuda.h>
#include <cuda_runtime.h>
#include <cuda_device_runtime_api.h>
#include <stdio.h>
#include <stdlib.h>
#include "bmp.h"
__global__ void GPU_ChangeRGB(int *D_R, int *D_G, int *D_B, int *GPU_R, int *GPU_G, int *GPU_B, int *offest){
	int index = threadIdx.x + blockIdx.x*blockDim.x;
	printf("r:%d g:%d b:%d\n",offest[0],offest[1],offest[2]);
	if(offest[0] == 0 && offest[1] == 0){
		GPU_R[index] = D_R[index];
		GPU_G[index] = D_G[index];
		GPU_B[index] = D_B[index] + offest[2];
	}
	else if (offest[1] == 0 && offest[2] == 0){
		GPU_R[index] = D_R[index] + offest[0];
		GPU_G[index] = D_G[index];
		GPU_B[index] = D_B[index];
	}
	else if (offest[0] == 0 && offest[2] == 0){
		GPU_R[index] = D_R[index];
		GPU_G[index] = D_G[index] + offest[1];
		GPU_B[index] = D_B[index];
	}
	else{
		GPU_R[index] = D_R[index] + offest[0];
		GPU_G[index] = D_G[index] + offest[1];
		GPU_B[index] = D_B[index] + offest[2];
	}
}

void Cuda_Change_RGB(int (&R)[MaxBMPSizeX][MaxBMPSizeY], int (&G)[MaxBMPSizeX][MaxBMPSizeY], int (&B)[MaxBMPSizeX][MaxBMPSizeY],
                     int (&r)[MaxBMPSizeX][MaxBMPSizeY], int (&g)[MaxBMPSizeX][MaxBMPSizeY], int (&b)[MaxBMPSizeX][MaxBMPSizeY],
                     int width,int height,int (&rgb_offest)[3]){
	int i,j;
	int Flat_R[width*height];
	int Flat_G[width*height];
	int Flat_B[width*height];
	// 2-D converting to 1-D array
	for(i=0;i<height;i++){
		for(j=0;j<width;j++){
			Flat_R[i*width+j] = R[i][j];
			Flat_G[i*width+j] = G[i][j];
			Flat_B[i*width+j] = B[i][j];
		}	
	}
	int *GPU_R = NULL, *GPU_G = NULL, *GPU_B = NULL,*D_R = NULL,*D_G = NULL,*D_B = NULL;
	int *offest = NULL;	
	//allocated gpu memory to 3 2-D array (R,G,B)
	cudaMalloc(&D_R, sizeof(int)*width*height);
	cudaMalloc(&D_G, sizeof(int)*width*height);
	cudaMalloc(&D_B, sizeof(int)*width*height);
	cudaMalloc(&GPU_R, sizeof(int)*width*height);
	cudaMalloc(&GPU_G, sizeof(int)*width*height);
	cudaMalloc(&GPU_B, sizeof(int)*width*height);
	cudaMalloc(&offest, sizeof(int)*3);	
	cudaMemset(D_R,255,sizeof(int)*width*height);
	cudaMemset(D_G,255,sizeof(int)*width*height);
	cudaMemset(D_B,255,sizeof(int)*width*height);
	cudaMemset(GPU_R,255,sizeof(int)*width*height);
	cudaMemset(GPU_G,255,sizeof(int)*width*height);
	cudaMemset(GPU_B,255,sizeof(int)*width*height);
	cudaMemset(offest,0,sizeof(int)*3);
	// from cpu replicate data to gpu memory	
	cudaMemcpy(D_R, Flat_R, sizeof(int)*width*height, cudaMemcpyHostToDevice);
	cudaMemcpy(D_G, Flat_G, sizeof(int)*width*height, cudaMemcpyHostToDevice);
	cudaMemcpy(D_B, Flat_B, sizeof(int)*width*height, cudaMemcpyHostToDevice);
	cudaMemcpy(offest,rgb_offest,sizeof(int)*3, cudaMemcpyHostToDevice);
	// kernel function
	GPU_ChangeRGB<<<height,width>>>(D_R, D_G, D_B, GPU_R, GPU_G, GPU_B, offest);
	// from GPU copy processed data back to CPU memroy
	int Pass_R[width*height];
	int Pass_G[width*height];
	int Pass_B[width*height];	
	cudaMemcpy(Pass_R, GPU_R, sizeof(int)*width*height, cudaMemcpyDeviceToHost);
	cudaMemcpy(Pass_G, GPU_G, sizeof(int)*width*height, cudaMemcpyDeviceToHost);
	cudaMemcpy(Pass_B, GPU_B, sizeof(int)*width*height, cudaMemcpyDeviceToHost);
	// 1-D converting to 2-D array
	for(i=0;i<height;i++){
		for(j=0;j<width;j++){
			r[i][j] = Pass_R[i*width+j];
			g[i][j] = Pass_G[i*width+j];
			b[i][j] = Pass_B[i*width+j];
		}	
	}
}
