#!/bin/bash

# Show help and exit
[[ "$1" == "-h" || "$1" == "--help" ]] && cat << EOF && exit 0
Usage: $(basename "$0") [-b BRANCH] [DIRECTORY]

Setup federation repository (default: federation, branch: master/main)

Options:
  -b BRANCH     Checkout specific branch after clone
  -h, --help    Show this help

Examples:
  $(basename "$0")                      # Default directory and branch
  $(basename "$0") my-fed               # Custom directory
  $(basename "$0") -b develop           # Specific branch, default directory
  $(basename "$0") -b develop my-fed    # Specific branch and directory
EOF

# Parse arguments
BRANCH=""
DIR="federation"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -b)
            BRANCH="$2"
            shift 2
            ;;
        *)
            DIR="$1"
            shift
            ;;
    esac
done

# Check if directory exists and add timestamp
[[ -d "$DIR" ]] && DIR="federation.$(date +%Y%m%d%H%M%S)" && echo "Using: $DIR"

# Clone
git clone --dissociate --reference-if-able /work/github-cache/federation.git \
    git@github.com:sifive/federation "$DIR" && \
cd "$DIR" && \
{ [[ -n "$BRANCH" ]] && git checkout "$BRANCH" || true; } && \
./scripts/quick-submodule-update