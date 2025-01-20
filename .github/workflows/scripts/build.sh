#!/bin/bash
set -eux

python_executable=python$1
cuda_home=/usr/local/cuda-$2

# Update paths
PATH=${cuda_home}/bin:$PATH
LD_LIBRARY_PATH=${cuda_home}/lib64:$LD_LIBRARY_PATH

# Install requirements
$python_executable -m pip install -r requirements-build.txt -r requirements-cuda.txt

# Limit the number of parallel jobs to avoid OOM
export MAX_JOBS=1
# Make sure release wheels are built for the following architectures
export TORCH_CUDA_ARCH_LIST="6.0 6.1 6.2"

bash tools/check_repo.sh

# Build
$python_executable setup.py bdist_wheel --dist-dir=dist
