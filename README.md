# FLUX.1-dev: Gradio + vLLM-Omni

```
Browser ──► Gradio (frontend/app.py, :7860) ──HTTP──► vLLM-Omni (:8000, /v1/images/generations) ──► FLUX.1-dev on GPU
```

## Requirements
- Linux (or WSL2) with an NVIDIA GPU. FLUX.1-dev in bf16 needs about 24 GB+ of VRAM, and more for large images.
  vLLM does not run natively on Windows.
- Access to the gated model: accept the license at https://huggingface.co/black-forest-labs/FLUX.1-dev
  and create an HF token.

## Option A: Docker Compose
```bash
cp .env.example .env        # put your HF_TOKEN in it
docker compose up --build
```
Open http://localhost:7860. The first start downloads about 30 GB of weights. The frontend waits until the backend reports healthy.

## Option B: Run manually
Backend:
```bash
uv venv --python 3.12 --seed && source .venv/bin/activate
uv pip install vllm==0.32.0 --torch-backend=cu130
uv pip install vllm-omni==0.32.0
export HF_TOKEN=hf_xxx
bash backend/serve.sh            # extra args are passed to `vllm serve`
```
Frontend (on the same host or any other host):
```bash
pip install -r frontend/requirements.txt
BACKEND_URL=http://<gpu-host>:8000 python frontend/app.py
```

## Test the backend directly
```bash
curl -s http://localhost:8000/v1/images/generations -H 'Content-Type: application/json' \
  -d '{"prompt":"a cat holding a sign that says hello world","size":"1024x1024","num_inference_steps":28,"guidance_scale":3.5,"seed":42}' \
  | jq -r '.data[0].b64_json' | base64 -d > out.png
```

## Frontend env vars
| Var | Default |
|---|---|
| `BACKEND_URL` | `http://localhost:8000` |
| `MODEL` | `black-forest-labs/FLUX.1-dev` |
| `REQUEST_TIMEOUT` | `600` (seconds) |
| `GRADIO_HOST` / `GRADIO_PORT` | `0.0.0.0` / `7860` |
