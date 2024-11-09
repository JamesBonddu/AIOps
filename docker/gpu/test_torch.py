import torch

print(f"PyTorch version: {torch.__version__}")
print(f"cuDNN version: {torch.backends.cudnn.version()}")
print(f"CUDA available: {torch.cuda.is_available()}")
