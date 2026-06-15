#!/usr/bin/env bash
# Ensure /usr/bin/python resolves to 3.12 for tasks/wrappers pinned to 3.12.
# Does NOT install task Python libraries (those come from the task's input/runtime_env
# via uv at solve time). Independent of the ALE framework venv (/opt/ale-run/.venv).
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
if [ ! -x /usr/bin/python3.12 ]; then
  apt-get update -qq && apt-get install -y -qq python3.12 && rm -rf /var/lib/apt/lists/*
fi
test -x /usr/bin/python3.12 || { echo "[pkg python-default-3.12] FATAL: python3.12 unavailable" >&2; exit 1; }
# Force the symlink (don't skip if /usr/bin/python already exists pointing at 3.10).
ln -sf /usr/bin/python3.12 /usr/bin/python
/usr/bin/python --version 2>&1 | grep -q "Python 3.12" || { echo "[pkg python-default-3.12] FATAL: /usr/bin/python is not 3.12" >&2; exit 1; }
echo "[pkg python-default-3.12] OK ($(/usr/bin/python --version 2>&1))"
