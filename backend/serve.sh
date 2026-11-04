#!/usr/bin/env bash
# Start the vLLM-Omni server for FLUX.1-dev (Linux + NVIDIA GPU).
# Install first:
#   uv venv --python 3.12 --seed && source .venv/bin/activate
#   uv pip install vllm==0.32.0 --torch-backend=cu130
#   uv pip install vllm-omni==0.32.0
# FLUX.1-dev is gated: accept the license on Hugging Face, then export HF_TOKEN.
set -euo pipefail

MODEL="${MODEL:-black-forest-labs/FLUX.1-dev}"
PORT="${PORT:-8000}"

if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "warning: HF_TOKEN is not set; downloading the gated FLUX.1-dev weights will fail." >&2
fi

exec vllm serve "$MODEL" --omni --host 0.0.0.0 --port "$PORT" "$@"
