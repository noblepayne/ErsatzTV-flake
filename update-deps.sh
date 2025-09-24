#!/usr/bin/env bash
set -euo pipefail

nix build .#default.fetch-deps --out-link fetch-deps
./fetch-deps ./deps.json 
rm ./fetch-deps 
