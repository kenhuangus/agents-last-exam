#!/usr/bin/env bash
# Ensure /usr/bin/python resolves to 3.10 for task wrappers that call `python` or
# whose runtime pins ==3.10.*. This does NOT install the task's Python libraries —
# those come from each task's own input/runtime_env via uv at solve time (policy).
# Note: the ALE framework runs under its own venv (/opt/ale-run/.venv, py3.12);
# /usr/bin/python is the task-SOLUTION interpreter, independent of the framework.
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
if [ ! -x /usr/bin/python3.10 ]; then
  apt-get update -qq && apt-get install -y -qq python3.10 && rm -rf /var/lib/apt/lists/*
fi
test -x /usr/bin/python3.10 || { echo "[pkg python-default-3.10] FATAL: python3.10 unavailable" >&2; exit 1; }
# Force the symlink (don't skip if /usr/bin/python already exists pointing elsewhere,
# e.g. an image where python -> 3.12).
ln -sf /usr/bin/python3.10 /usr/bin/python
/usr/bin/python --version 2>&1 | grep -q "Python 3.10" || { echo "[pkg python-default-3.10] FATAL: /usr/bin/python is not 3.10" >&2; exit 1; }
echo "[pkg python-default-3.10] OK ($(/usr/bin/python --version 2>&1))"
