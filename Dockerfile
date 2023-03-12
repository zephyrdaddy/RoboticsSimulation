ARG IMAGE_NAME
FROM ${IMAGE_NAME}:12.1.0-runtime-ubuntu18.04 as base

ENV NV_CUDA_LIB_VERSION "12.1.0-1"

FROM base as base-amd64

ENV NV_CUDA_CUDART_DEV_VERSION 12.1.55-1
ENV NV_NVML_DEV_VERSION 12.1.55-1
ENV NV_LIBCUSPARSE_DEV_VERSION 12.0.2.55-1
ENV NV_LIBNPP_DEV_VERSION 12.0.2.50-1
ENV NV_LIBNPP_DEV_PACKAGE libnpp-dev-12-1=${NV_LIBNPP_DEV_VERSION}

ENV NV_LIBCUBLAS_DEV_VERSION 12.1.0.26-1
ENV NV_LIBCUBLAS_DEV_PACKAGE_NAME libcublas-dev-12-1
ENV NV_LIBCUBLAS_DEV_PACKAGE ${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}

ENV NV_NVPROF_VERSION 12.1.55-1
ENV NV_NVPROF_DEV_PACKAGE cuda-nvprof-12-1=${NV_NVPROF_VERSION}

# FROM base-${TARGETARCH}

# ARG TARGETARCH

LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-dev-12-1=${NV_CUDA_CUDART_DEV_VERSION} \
    cuda-command-line-tools-12-1=${NV_CUDA_LIB_VERSION} \
    cuda-minimal-build-12-1=${NV_CUDA_LIB_VERSION} \
    cuda-libraries-dev-12-1=${NV_CUDA_LIB_VERSION} \
    cuda-nvml-dev-12-1=${NV_NVML_DEV_VERSION} \
    ${NV_NVPROF_DEV_PACKAGE} \
    ${NV_LIBNPP_DEV_PACKAGE} \
    libcusparse-dev-12-1=${NV_LIBCUSPARSE_DEV_VERSION} \
    ${NV_LIBCUBLAS_DEV_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold ${NV_LIBCUBLAS_DEV_PACKAGE_NAME}
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

ARG BOOST_VERSION=1.80.0

# install dependencies via apt
ENV DEBCONF_NOWARNINGS yes
RUN set -x && \
  apt-get update -y -qq && \
  apt-get upgrade -y -qq --no-install-recommends && \
  : "basic dependencies" && \
  apt-get install -y -qq \
    build-essential \
    pkg-config \
    cmake \
    git \
    git-core \
    wget \
    curl \
    tar \
    libeigen3-dev \
    unzip && \
  : "bazel dependencies and bazel" && \
  apt-get install -y -qq \
    zip \
    g++ \
    zlib1g-dev \
    python3 \
    openjdk-8-jdk && \
    echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && \
    apt-get -y install bazel && \
    apt-get -y upgrade bazel && \
    bazel version && \
  : "other dependencies" && \
  apt-get install -y -qq \
    libyaml-cpp-dev && \
  : "remove cache" && \
  apt-get install -y vim htop && \
  apt-get autoremove -y -qq && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y -qq \
    libglfw3 libglfw3-dev && \
    rm -rf /var/lib/apt/lists/*

# RUN apt-get update && apt-get install -y --no-install-recommends \
#         pkg-config \
#         libglvnd-dev libglvnd-dev:i386 \
#         libgl1-mesa-dev libgl1-mesa-dev:i386 \
#         libegl1-mesa-dev libegl1-mesa-dev:i386 \
#         libgles2-mesa-dev libgles2-mesa-dev:i386 && \
#     rm -rf /var/lib/apt/lists/*

ARG CMAKE_INSTALL_PREFIX=/usr/local
ARG NUM_THREADS=1

ENV CPATH=${CMAKE_INSTALL_PREFIX}/include:${CPATH}
ENV C_INCLUDE_PATH=${CMAKE_INSTALL_PREFIX}/include:${C_INCLUDE_PATH}
ENV CPLUS_INCLUDE_PATH=${CMAKE_INSTALL_PREFIX}/include:${CPLUS_INCLUDE_PATH}
ENV LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:${LIBRARY_PATH}
ENV LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/lib:${LD_LIBRARY_PATH}

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# RBDL
ARG RBDL_VERSION=3.2.1
WORKDIR /tmp
RUN set -x && \
  wget -q https://github.com/rbdl/rbdl/archive/refs/tags/v${RBDL_VERSION}.zip && \
  unzip -q v${RBDL_VERSION}.zip && \
  rm -rf v${RBDL_VERSION}.zip && \
  cd rbdl-${RBDL_VERSION} && \
  mkdir -p build && \
  cd build && \
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
    .. && \
  make -j${NUM_THREADS} && \
  make install && \
  cd /tmp && \
  rm -rf *
ENV RBDL_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/rbdl


# Install rapidjson from source
RUN cd /opt && \
    curl -kOL https://github.com/miloyip/rapidjson/archive/v1.1.0.tar.gz && \
    tar xfz v1.1.0.tar.gz && \
    mv rapidjson-1.1.0/include/rapidjson/ /usr/local/include 

RUN rm -rf  /opt/rapidjson-1.1.0 

# OSQP
ARG OSQP_VERSION=0.6.2
WORKDIR /tmp
RUN set -x && \
  wget -q https://github.com/osqp/osqp/releases/download/v${OSQP_VERSION}/complete_sources.zip && \
  unzip -q complete_sources.zip && \
  rm -rf complete_sources.zip && \
  cd osqp && \
  mkdir -p build && \
  cd build && \
  cmake \
    -G "Unix Makefiles" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
    .. && \
  make -j${NUM_THREADS} && \
  make install && \
  cd /tmp && \
  rm -rf *
ENV OSQP_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/osqp

# qpOASES
ARG QP_OASES_VERSION=3.2.1
WORKDIR /tmp
RUN set -x && \
  wget -q https://github.com/coin-or/qpOASES/archive/refs/tags/releases/${QP_OASES_VERSION}.zip && \
  unzip -q ${QP_OASES_VERSION}.zip && \
  rm -rf ${QP_OASES_VERSION}.zip && \
  cd qpOASES-releases-${QP_OASES_VERSION} && \
  mkdir -p build && \
  cd build && \
  cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} \
    .. && \
  make -j${NUM_THREADS} && \
  make install && \
  cd /tmp && \
  rm -rf *
ENV QP_OASES_DIR=${CMAKE_INSTALL_PREFIX}/lib/cmake/qp_oases




# Set up the bazel setting
RUN echo "build --copt=-fdiagnostics-color=always\nrun --copt=-fdiagnostics-color=always" >> /etc/bazel.bazelrc 
# libnvidia-gl-440 

# Set up workspace
# RUN mkdir -p /usr/visual_frontend
ENV WORKSPACE /usr/master-robotics
WORKDIR /usr/master-robotics
ENTRYPOINT ["/bin/bash"]
