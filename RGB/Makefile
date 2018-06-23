CXX = g++
NVCC = nvcc
-arch=sm_30 \arch=sm_30 \
 -gencode=arch=compute_20,code=sm_20 \
 -gencode=arch=compute_30,code=sm_30 \
 -gencode=arch=compute_50,code=sm_50 \
 -gencode=arch=compute_52,code=sm_52 \
 -gencode=arch=compute_60,code=sm_60 \
 -gencode=arch=compute_61,code=sm_61 \
 -gencode=arch=compute_61,code=compute_61
SRC = ./src/
RGB:
	$(CXX) -c $(SRC)*.cpp
	$(CXX) *.o -o RGB
	rm -rf *.o
RGB_G:
	$(CXX) -c $(SRC)main.cpp $(SRC)bmp.cpp $(SRC)edge.cpp
	$(NVCC) -c -gencode=arch=compute_50,code=sm_50 \
 -gencode=arch=compute_52,code=sm_52 $(SRC)*.cu 
	$(CXX) *.o -L/usr/local/cuda/lib64 -lcudart -lcuda -o RGB_G
	rm -rf *.o
clean:
	rm -rf *.o RGB RGB_G
