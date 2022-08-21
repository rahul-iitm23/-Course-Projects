#include<iostream>
#include<sys/time.h>
#include<cuda.h>
using namespace std;

__global__ void matmul(int * a, int *b, int *res,int n)  // for multip.. of CD^T
{
	int i = blockIdx.x;
	int j = threadIdx.x;
	int sum = 0;
	for(int k=0;k<n;k++)
	{
		sum += a[i*n+k]* b[j*n+k];
	}

	res[i*blockDim.x + j] = sum;

}


// write kernels here...
__global__ void a_plus_bt(int *matrixA, int *matrixBT,int p,int q)
{
	extern __shared__ int f[];
	f[threadIdx.x] = matrixA[blockIdx.x*blockDim.x + threadIdx.x];
	matrixA[blockIdx.x*blockDim.x + threadIdx.x] = f[threadIdx.x] + matrixBT[blockIdx.x*blockDim.x + threadIdx.x];

}

__global__ void transpose(int *mat, int *res)
{
res[threadIdx.x*gridDim.x + blockIdx.x]  =  mat[blockIdx.x*blockDim.x+threadIdx.x];
}
// function to compute the output matrix
void compute(int p, int q, int r, int s, int *h_matrixA, int *h_matrixB, 
	         int *h_matrixC, int *h_matrixD, int *h_matrixX) {
	// variable declarations...
	int *matrixA, *matrixB, *matrixC, *matrixD;
	int *matrixBT, *matrixDT;
    int *cdtt ; // for storing (C D^T)^T
    int *res;
	// allocate memory...
	cudaMalloc(&matrixA, p*q*sizeof(int));
	cudaMalloc(&matrixB, q*p*sizeof(int));
	cudaMalloc(&matrixC, q*r*sizeof(int));
	cudaMalloc(&matrixD, s*r*sizeof(int));
	cudaMalloc(&matrixBT, p*q*sizeof(int));
	cudaMalloc(&matrixDT, r*s*sizeof(int));
	cudaMalloc(&cdtt, s*q*sizeof(int));
	cudaMalloc(&res, p*s*sizeof(int));

	// copy the values...
	cudaMemcpy(matrixA, h_matrixA, p*q*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(matrixB, h_matrixB, q*p*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(matrixC, h_matrixC, q*r*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(matrixD, h_matrixD, s*r*sizeof(int), cudaMemcpyHostToDevice);

	// call the kernels for doing required computations...
	transpose<<<q,p>>>(matrixB, matrixBT);
	//transpose<<<s,r>>>(matrixD, matrixDT);//to increase memory cohelesing do not transpose matrix D
	int *matrixCDT;
	cudaMalloc(&matrixCDT, q*s*sizeof(int));

	matmul<<<q,s>>>(matrixC, matrixD,matrixCDT,r);

	a_plus_bt<<<p,q, q*sizeof(int)>>>(matrixA, matrixBT,p,q);// After this kernel execution matrixA have (A+B^T)
	cudaFree(matrixC);
	cudaFree(matrixB);
	cudaFree(matrixD);
	transpose<<<q,s>>>(matrixCDT, cdtt);
	matmul<<<p,s>>>(matrixA, cdtt, res, q);
	// copy the result back...
	cudaMemcpy(h_matrixX, res,p*s*sizeof(int), cudaMemcpyDeviceToHost);
	
	// deallocate the memory...
	cudaFree(cdtt);
	cudaFree(matrixCDT);
	cudaFree(matrixA);
}

// function to read the input matrices from the input file
void readMatrix(FILE *inputFilePtr, int *matrix, int rows, int cols) {
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			fscanf(inputFilePtr, "%d", &matrix[i*cols+j]);
		}
	}
}

// function to write the output matrix into the output file
void writeMatrix(FILE *outputFilePtr, int *matrix, int rows, int cols) {
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			fprintf(outputFilePtr, "%d ", matrix[i*cols+j]);
		}
		fprintf(outputFilePtr, "\n");
	}
}

int main(int argc, char **argv) {
	// variable declarations
	int p, q, r, s;
	int *matrixA, *matrixB, *matrixC, *matrixD, *matrixX;
	struct timeval t1, t2;
	double seconds, microSeconds;

	// get file names from command line
	char *inputFileName = argv[1];
	char *outputFileName = argv[2];

	// file pointers
	FILE *inputFilePtr, *outputFilePtr;
    
    inputFilePtr = fopen(inputFileName, "r");
	if(inputFilePtr == NULL) {
	    printf("Failed to open the input file.!!\n"); 
		return 0;
	}

	// read input values
	fscanf(inputFilePtr, "%d %d %d %d", &p, &q, &r, &s);

	// allocate memory and read input matrices
	matrixA = (int*) malloc(p * q * sizeof(int));
	matrixB = (int*) malloc(q * p * sizeof(int));
	matrixC = (int*) malloc(q * r * sizeof(int));
	matrixD = (int*) malloc(s * r * sizeof(int));
	readMatrix(inputFilePtr, matrixA, p, q);
	readMatrix(inputFilePtr, matrixB, q, p);
	readMatrix(inputFilePtr, matrixC, q, r);
	readMatrix(inputFilePtr, matrixD, s, r);

	// allocate memory for output matrix
	matrixX = (int*) malloc(p * s * sizeof(int));

	// call compute function to get the output matrix. it is expected that 
	// the compute function will store the result in matrixX.
	gettimeofday(&t1, NULL);
	compute(p, q, r, s, matrixA, matrixB, matrixC, matrixD, matrixX);
	cudaDeviceSynchronize();
	gettimeofday(&t2, NULL);

	// print the time taken by the compute function
	seconds = t2.tv_sec - t1.tv_sec;
	microSeconds = t2.tv_usec - t1.tv_usec;
	printf("Time taken (ms): %.3f\n", 1000*seconds + microSeconds/1000);

	// store the result into the output file
	outputFilePtr = fopen(outputFileName, "w");
	writeMatrix(outputFilePtr, matrixX, p, s);

	// close files
    fclose(inputFilePtr);
    fclose(outputFilePtr);

	// deallocate memory
	free(matrixA);
	free(matrixB);
	free(matrixC);
	free(matrixD);
	free(matrixX);

	return 0;
}