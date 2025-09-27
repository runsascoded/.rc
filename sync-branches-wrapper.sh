#!/bin/bash
# Run sync-branches.py using Python's isolated mode to avoid import conflicts
# Stay in the current directory (the repo) but use -I to prevent local imports
exec uv run --with click --with gitpython --with utz python -I sync-branches.py "$@"
