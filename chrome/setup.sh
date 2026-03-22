#!/usr/bin/env bash
#
# Configure Chrome for reduced glare / dark web content.
# Quit Chrome before running this.

set -euo pipefail

LOCAL_STATE="$HOME/Library/Application Support/Google/Chrome/Local State"

if pgrep -xq "Google Chrome"; then
  echo "error: quit Chrome first" >&2
  exit 1
fi

if [[ ! -f "$LOCAL_STATE" ]]; then
  echo "error: Chrome Local State not found — launch Chrome once first" >&2
  exit 1
fi

# Enable force-dark for web content (same as chrome://flags/#enable-force-dark)
python3 -c "
import json, sys

with open(sys.argv[1], 'r') as f:
    state = json.load(f)

experiments = state.setdefault('browser', {}).setdefault('enabled_labs_experiments', [])

# Remove any existing force-dark entry, then add enabled
experiments = [e for e in experiments if not e.startswith('enable-force-dark')]
experiments.append('enable-force-dark@1')
state['browser']['enabled_labs_experiments'] = experiments

with open(sys.argv[1], 'w') as f:
    json.dump(state, f)

print('Chrome force-dark enabled')
" "$LOCAL_STATE"
