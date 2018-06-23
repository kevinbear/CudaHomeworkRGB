#include <cuda.h>
#include <cuda_runtime.h>
#include <cuda_device_runtime_api.h>
#include <stdio.h>
#include <stdlib.h>
#include "bmp.h"
__global__ void GPU_ChangeRGB(int R[MaxBMPSizeX][MaxBMPSizeY], int G[MaxBMPSizeX][MaxBMPSizeY], int B[MaxBMPSizeX][MaxBMPSizeY], int *GPU_R, int *GPU_G, int *GPU_B, int rgb_offest[3], int width, int height){
	
	int index = threadIdx.x + blockIdx.x*blockDim.x;
	
	if(rgb_offest[0] == 0 && rgb_offest[1] == 0){
		GPU_R[index] = R[blockIdx.x][threadIdx.x];
		GPU_G[index] = G[blockIdx.x][threadIdx.x];
		GPU_B[index] = B[blockIdx.x][threadIdx.x] + rgb_offest[2];
	}
	else if (rgb_offest[1] == 0 && rgb_offest[2] == 0){
		GPU_R[index] = R[blockIdx.x][threadIdx.x] + rgb_offest[0];
		GPU_G[index] = G[blockIdx.x][threadIdx.x];
		GPU_B[index] = B[blockIdx.x][threadIdx.x];
	}
	else if (rgb_offest[0] == 0 && rgb_offest[2] == 0){
		GPU_R[index] = R[blockIdx.x][threadIdx.x];
		GPU_G[index] = G[blockIdx.x][threadIdx.x] + rgb_offest[1];
		GPU_B[index] = B[blockIdx.x][threadIdx.x];
	}
	else{
		GPU_R[index] = R[blockIdx.x][threadIdx.x] + rgb_offest[0];
		GPU_G[index] = G[blockIdx.x][threadIdx.x] + rgb_offest[1];
		GPU_B[index] = B[blockIdx.x][threadIdx.x] + rgb_offest[2];
	}
}

void Cuda_Change_RGB(int (&R)[MaxBMPSizeX][MaxBMPSizeY], int (&G)[MaxBMPSizeX][MaxBMPSizeY], int (&B)[MaxBMPSizeX][MaxBMPSizeY],
                     int (&r)[MaxBMPSizeX][MaxBMPSizeY], int (&g)[MaxBMPSizeX][MaxBMPSizeY], int (&b)[MaxBMPSizeX][MaxBMPSizeY],
                     int width,int height,int (&rgb_offest)[3]){
		
	int *GPU_R, *GPU_G, *GPU_B;
	size_t pitch_r,pitch_g,pitch_b;
	//allocated gpu memory to 3 2-D array (R,G,B)
	cudaMallocPitch(&GPU_R, &pitch_r, sizeof(int*)*MaxBMPSizeX, MaxBMPSizeY);
	cudaMallocPitch(&GPU_G, &pitch_g, sizeof(int*)*MaxBMPSizeX, MaxBMPSizeY);
	cudaMallocPitch(&GPU_B, &pitch_b, sizeof(int*)*MaxBMPSizeX, MaxBMPSizeY);
	// from cpu replicate data to gpu memory	
	cudaMemcpy2D(GPU_R, pitch_r, R, sizeof(int*)*MaxBMPSizeX, sizeof(int*)*MaxBMPSizeX, MaxBMPSizeY, cudaMemcpyHostToDevice);
	cudaMemcpy2D(GPU_G, pitch_g, G, sizeof(int*)*MaxBMPSizeX, sizeof(int*)*MaxBMPSizeX, MaxBMPSizeY, cudaMemcpyHostToDevice);
	cudaMemcpy2D(GPU_B, pitch_b, B, sizeof(int*)*MaxBMPSizeX, sizeof(int*)*MaxBMPSizeX, MaxBMPSizeY, cudaMemcpyHostToDevice);
	// kernel function
	GPU_ChangeRGB<<<height,width>>>(R, G, B, GPU_R, GPU_G, GPU_B, rgb_offest, width, height);
	// from GPU copy processed data back to CPU memroy
	cudaMemcpy2D(r, sizeof(int*)*MaxBMPSizeX, GPU_R, pitch_r, sizeof(int*)*MaxBMPSizeX, MaxBMPSizeY, cudaMemcpyDeviceToHost);
	cudaMemcpy2D(g, sizeof(int*)*MaxBMPSizeX, GPU_G, pitch_g, sizeof(int*)*MaxBMPSizeX, MaxBMPSizeY, cudaMemcpyDeviceToHost);
	cudaMemcpy2D(b, sizeof(int*)*MaxBMPSizeX, GPU_B, pitch_b, sizeof(int*)*MaxBMPSizeX, MaxBMPSizeY, cudaMemcpyDeviceToHost);
}
