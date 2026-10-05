#!/usr/bin/env bash
# Lite path: pure Python, in-process Qdrant, SQLite Feast online store.
# Uses an existing Conda environment; does not create a virtual environment.
# No Docker, no GPU, no external services.

set -euo pipefail

echo "[lite] Day 19 lightweight setup (Conda)"
echo "[lite] Stack: fastembed + qdrant-client[memory] + rank-bm25 + feast(sqlite) + FastAPI"
echo

# Run relative to this script, even when invoked from another directory.
cd "$(dirname "${BASH_SOURCE[0]}")"

# ── 1. Activate an existing Conda environment ───────────────────────────
CONDA_ENV_NAME="${1:-env_vinai_lab}"
if [ "$#" -gt 1 ]; then
  echo "Usage: bash setup-lite-conda.sh [environment-name]" >&2
  exit 1
fi

# Conda may not be on PATH in a non-interactive shell.
if ! command -v conda >/dev/null 2>&1; then
  for conda_root in "$HOME/miniconda3" "$HOME/miniconda" "$HOME/anaconda3" "$HOME/miniforge3"; do
    if [ -f "$conda_root/etc/profile.d/conda.sh" ]; then
      # shellcheck source=/dev/null
      source "$conda_root/etc/profile.d/conda.sh"
      break
    fi
  done
fi
if ! command -v conda >/dev/null 2>&1; then
  echo "[lite] Conda not found. Initialize Conda in your shell and rerun this script." >&2
  exit 1
fi
# Load shell support for `conda activate` when conda is only an executable.
eval "$(conda shell.bash hook)"
if ! conda activate "$CONDA_ENV_NAME"; then
  echo "[lite] Could not activate existing Conda environment '$CONDA_ENV_NAME'." >&2
  exit 1
fi

# ── 2. Check the environment's Python ───────────────────────────────────
python -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else "Python 3.10+ is required in this Conda environment.")'
ENV_PY_VER=$(python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
NEED_DILL_OVERRIDE=$(python -c 'import sys; print(1 if sys.version_info >= (3,14) else 0)')
echo "[lite] Conda environment $CONDA_ENV_NAME: Python $ENV_PY_VER"

# ── 3. Install deps into the activated Conda environment ────────────────
# Use the selected Python explicitly so installs cannot target a local .venv.
python -m pip install -q -U pip
python -m pip install -q -r requirements.txt
if [ "$NEED_DILL_OVERRIDE" = "1" ]; then
  echo "[lite] Python >= 3.14 -> applying dill>=0.4 override (feast's pin is too old; see requirements.txt)"
  python -m pip install -q --upgrade 'dill>=0.4,<1.0'
fi

# ── 4. Convert Jupytext sources to .ipynb ───────────────────────────────
# `_setup.py` is a helper module, not a notebook -- converting it produces
# a _setup.ipynb that fails on execute. Only convert numbered notebooks.
python -m jupytext --to notebook --update notebooks/[0-9]*.py 2>/dev/null || python -m jupytext --to notebook notebooks/[0-9]*.py

# ── 5. .env scaffold ────────────────────────────────────────────────────
[ -f .env ] || cp .env.example .env

# ── 6. Seed corpus + golden set ─────────────────────────────────────────
python scripts/seed_corpus.py

# Data for the advanced missions (NB6 compound queries, NB8 spend parquet).
# gen_agent_queries embeds the corpus once to build brute-force ground truth,
# so this adds ~20 s -- worth it: the alternative is students hand-labelling.
echo "  · seeding advanced-mission data (NB6 + NB8)…"
python scripts/gen_agent_queries.py
python scripts/gen_spend.py

# ── 7. Smoke test ───────────────────────────────────────────────────────
python scripts/verify_lite.py

cat <<EOF

[lite] Done. Activate your Conda environment in your terminal and start working:

    conda activate "$CONDA_ENV_NAME"
    make VENV="\$CONDA_PREFIX" api       # start FastAPI on :8000
    make VENV="\$CONDA_PREFIX" lab       # open Jupyter on :8888
    make VENV="\$CONDA_PREFIX" benchmark # Precision@10 + latency table

Tip: read VIBE-CODING.md before starting NB1 — it tells you what to delegate
to your AI assistant and what to think through yourself.
EOF
