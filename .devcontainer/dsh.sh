#!/usr/bin/env bash
# Start the DeepSeek Harness Web UI inside this dev container.
#
# Runs the same entrypoint as `pnpm dsh web`, but directly through node: pnpm
# would run an implicit "verify deps" install first, which tries to rebuild the
# bind-mounted node_modules against this image.
set -euo pipefail

cd /opt/deepseek-harness

exec node --import tsx/esm apps/cli/src/bin.ts web \
  --host "$(hostname -i | awk '{print $1}')" \
  --port "${DSH_PORT:-3081}" \
  --no-open
