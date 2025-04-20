#include "add.cu"

int main() {
	instance_t          *instances, *gpuInstances;
	cgbn_error_report_t *report;

	printf("Genereating instances ...\n");
	instances=generate_instances(INSTANCES);

	printf("Copying instances to the GPU ...\n");
	CUDA_CHECK(cudaSetDevice(0));
	CUDA_CHECK(cudaMalloc((void **)&gpuInstances, sizeof(instance_t)*INSTANCES));
	CUDA_CHECK(cudaMemcpy(gpuInstances, instances, sizeof(instance_t)*INSTANCES, cudaMemcpyHostToDevice));

	// create a cgbn_error_report for CGBN to report back errors
	CUDA_CHECK(cgbn_error_report_alloc(&report));

	printf("Running GPU kernel ...\n");
	// launch with 32 threads per instance, 128 threads (4 instances) per block
	kernel_add<<<(INSTANCES+3)/4, 128>>>(report, gpuInstances, INSTANCES);

	// error report uses managed memory, so we sync the device (or stream) and check for cgbn errors
	CUDA_CHECK(cudaDeviceSynchronize());
	CGBN_CHECK(report);

	// copy the instances back from gpuMemory
	printf("Copying results back to CPU ...\n");
	CUDA_CHECK(cudaMemcpy(instances, gpuInstances, sizeof(instance_t)*INSTANCES, cudaMemcpyDeviceToHost));

	printf("Verifying the results ...\n");
	verify_results(instances, INSTANCES);

	// clean up
	free(instances);
	CUDA_CHECK(cudaFree(gpuInstances));
	CUDA_CHECK(cgbn_error_report_free(report));
}