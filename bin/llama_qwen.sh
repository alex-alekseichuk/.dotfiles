#!/bin/bash
unset GGML_CUDA_DISABLE_GRAPHS
unset GGML_CUDA_ENABLE_UNIFIED_MEMORY
llama serve \
  --model ~/models/gguf/Qwen3.8-27B-GSQ-RCO-IQ3_XXS.gguf \
  -md ~/models/gguf/Qwen3.8-27B-DFlash2-Q2_K.gguf \
  --spec-type draft-dflash \
  --device-draft CUDA0 \
  --n-gpu-layers-draft all \
  --ctx-size 120000 \
  --chat-template-kwargs '{"preserve_thinking":true}' \
  --jinja \
  --reasoning on \
  --reasoning-format deepseek \
  --reasoning-preserve \
  --flash-attn on \
  --cache-type-k q4_0 \
  --cache-type-v q4_0 \
  --fit off \
  --n-gpu-layers all \
  --threads 8 \
  --threads-batch 8 \
  --batch-size 512 \
  --ubatch-size 256 \
  --parallel 1 \
  --temp 1.0 \
  --top-p 0.95 \
  --top-k 20 \
  --min-p 0.0 \
  --presence-penalty 0.0 \
  --repeat-penalty 1.0 \
  --host 0.0.0.0 \
  --port 11434 \
  -lv 3 \
  --alias qwen3.8-27B-RCO-IQ3-local

