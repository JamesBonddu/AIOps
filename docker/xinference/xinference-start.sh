#!/bin/sh

# Run the second command
xinference-local --host 0.0.0.0 --port 9997 &

# Run the first command
ln -sf /usr/lib/x86_64-linux-gnu/libcuda.so.535.183.01 /usr/lib/x86_64-linux-gnu/libcuda.so.1

# python3 -m vllm.entrypoints.openai.api_server --model=/models/Qwen1.5-7B-Chat/Qwen/Qwen1___5-7B-Chat/ --max-model-len 4096 &
# xinference launch --model_path /models/merged_eletric_qwen2-7b-chat/ --model-engine vllm --max_model_len 2048 -n qwen1.5-chat -u eletric-qwen2-7b-chat  --tensor_parallel_size 1
