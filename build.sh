#!/bin/sh
# Pony Diffusion V6 XL — everything the worker image needs. The Dockerfile in your copy downloads this file
# from the original repo on every build, so fixes made there reach you with a rebuild.
set -eu
case "${CIVITAI_TOKEN:-}" in ""|PASTE_*) echo "ERROR: set CIVITAI_TOKEN at the top of the Dockerfile" >&2; exit 1;; esac

# file <dest> <url> <sha256>
file() {
  wget -q -O "$1" "$2"
  echo "$3  $1" | sha256sum -c - || { echo "ERROR: $1 changed upstream — wait for an update of the original repo, then rebuild" >&2; exit 1; }
}

# Pony Diffusion V6 XL V6 (start with this one) — SDXL checkpoint, fp16 pruned (Civitai model 257749 / version 290640, 6.8GB)
file /comfyui/models/checkpoints/pony_diffusion_v6_xl.safetensors \
  "https://civitai.com/api/download/models/290640?type=Model&format=SafeTensor&size=pruned&fp=fp16&token=${CIVITAI_TOKEN}" \
  67ab2fd8ec439a89b3fedb15cc65f54336af163c7eb5e4f2acc98f090a29b0b3
# SDXL runs on the ComfyUI of the base image as is
