# Default use the NVIDIA official image with PyTorch 2.3.0
# https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/index.html
ARG BASE_IMAGE=nvcr.io/nvidia/pytorch:22.12-py3
FROM ${BASE_IMAGE} as llamafactory-base

# Define environments
ENV MAX_JOBS=4
ENV FLASH_ATTENTION_FORCE_BUILD=TRUE
ENV VLLM_WORKER_MULTIPROC_METHOD=spawn

# Define installation arguments
ARG INSTALL_BNB=true
ARG INSTALL_VLLM=true
ARG INSTALL_DEEPSPEED=true
ARG INSTALL_FLASHATTN=true
ARG INSTALL_LIGER_KERNEL=true
ARG INSTALL_HQQ=true
ARG INSTALL_EETQ=false
ARG PIP_INDEX=https://pypi.org/simple

ENV http_proxy=http://localhost:27800
ENV https_proxy=http://localhost:27800

# Set the working directory
WORKDIR /app

# Install the requirements
COPY requirements.txt /app
RUN pip config set global.index-url "$PIP_INDEX" && \
    pip config set global.extra-index-url "$PIP_INDEX" && \
    pip config set global.http_proxy "$http_proxy" && \
    pip config set global.https_proxy "$https_proxy" && \
    python -m pip install --upgrade pip && \
    python -m pip install -r requirements.txt

FROM llamafactory-base AS llamafactory-base-packages
ENV http_proxy=http://localhost:27800
ENV https_proxy=http://localhost:27800
# Copy the rest of the application into the image
COPY . /app

# Install the LLaMA Factory
RUN EXTRA_PACKAGES="metrics"; \
    if [ "$INSTALL_BNB" == "true" ]; then \
        EXTRA_PACKAGES="${EXTRA_PACKAGES},bitsandbytes"; \
    fi; \
    if [ "$INSTALL_VLLM" == "true" ]; then \
        EXTRA_PACKAGES="${EXTRA_PACKAGES},vllm"; \
    fi; \
    if [ "$INSTALL_DEEPSPEED" == "true" ]; then \
        EXTRA_PACKAGES="${EXTRA_PACKAGES},deepspeed"; \
    fi; \
    if [ "$INSTALL_LIGER_KERNEL" == "true" ]; then \
        EXTRA_PACKAGES="${EXTRA_PACKAGES},liger-kernel"; \
    fi; \
    if [ "$INSTALL_HQQ" == "true" ]; then \
        EXTRA_PACKAGES="${EXTRA_PACKAGES},hqq"; \
    fi; \
    if [ "$INSTALL_EETQ" == "true" ]; then \
        EXTRA_PACKAGES="${EXTRA_PACKAGES},eetq"; \
    fi; \
    pip config set global.http_proxy "$http_proxy" && \
    pip config set global.https_proxy "$https_proxy" && \
    pip install -e ".[$EXTRA_PACKAGES]" --proxy http://localhost:27800

FROM llamafactory-base-packages AS llamafactory-flash-attention

RUN pip install torch=='2.3.0+cu118' torchvision \
    torchaudio=='2.3.0+cu118' \
    dash --index-url https://download.pytorch.org/whl/cu118 \
    --proxy http://localhost:27800

FROM llamafactory-flash-attention AS llamafactory-flash-attention-all

ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV CUDA_HOME=/usr/local/cuda
ENV CUDA_PATH=/usr/local/cuda

# Rebuild flash attention
RUN pip uninstall -y transformer-engine flash-attn && \
    if [ "$INSTALL_FLASHATTN" == "true" ]; then \
        pip uninstall -y ninja && pip install ninja && \
        ls /app && nvcc -V && python --version && \
        pip install https://github.com/Dao-AILab/flash-attention/releases/download/v2.5.9.post1/flash_attn-2.5.9.post1+cu118torch2.3cxx11abiTRUE-cp38-cp38-linux_x86_64.whl --proxy http://localhost:27800;\
        # pip install https://github.com/Dao-AILab/flash-attention/releases/download/v2.5.8/flash_attn-2.5.8+cu118torch2.3cxx11abiTRUE-cp310-cp310-linux_x86_64.whl --proxy http://localhost:27800;\
    fi

RUN pip install dash --proxy http://localhost:27800
# Set up volumes
# # 设置 CUDA 环境变量

VOLUME [ "/root/.cache/huggingface", "/root/.cache/modelscope", "/app/data", "/app/output" ]

# Expose port 7860 for the LLaMA Board
ENV GRADIO_SERVER_PORT 7860
EXPOSE 7860

# Expose port 8000 for the API service
ENV API_PORT 8000
EXPOSE 8000
