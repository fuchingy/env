#!/bin/bash

# Constants
PLAN_DIR="specs/test-planner-plans/sim/sparta/perf-valid"

# Show help and exit
[[ "$1" == "-h" || "$1" == "--help" ]] && cat << EOF && exit 0
Usage: $(basename "$0") [-l] [-d] [--local] YAML_FILE...

Run Federation test-planner with plan YAML files.

Options:
  -l, --list    List all available YAML files in perf-valid directory
  -d, --dry-run Run in dry-run mode (skip wake build)
      --local   Pass --local to test-planner script
  -h, --help    Show this help

Arguments:
  YAML_FILE     One or more YAML filenames (e.g., pacific_sn1.yaml)
                Single file: output = <filename>.json
                Multiple files: output = test_all.json

Examples:
  $(basename "$0") --list                           # List available YAMLs
  $(basename "$0") pacific_sn1.yaml                 # Full mode, output: pacific_sn1.json
  $(basename "$0") -d moray_sn2.yaml                # Dry-run mode
  $(basename "$0") --local pacific_sn1.yaml         # Local mode
  $(basename "$0") pacific_sn1.yaml moray_sn2.yaml  # Multiple files, output: test_all.json
EOF

# List YAML files and exit
[[ "$1" == "-l" || "$1" == "--list" ]] && ls -1 "$PLAN_DIR"/*.yaml 2>/dev/null | xargs -n1 basename && exit 0

# Parse arguments
DRY_RUN=false
LOCAL=false
YAML_FILES=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--dry-run) DRY_RUN=true; shift ;;
        --local) LOCAL=true; shift ;;
        -*) echo "Error: Unknown option $1" >&2; exit 1 ;;
        *) YAML_FILES+=("$1"); shift ;;
    esac
done

# Validate input
[[ ${#YAML_FILES[@]} -eq 0 ]] && echo "Error: No YAML files specified" >&2 && exit 1

# Build file arguments and validate
FILE_ARGS=()
for yaml in "${YAML_FILES[@]}"; do
    yaml_path="$PLAN_DIR/$yaml"
    [[ ! -f "$yaml_path" ]] && echo "Error: File not found: $yaml_path" >&2 && exit 1
    FILE_ARGS+=("--file" "$yaml_path")
done

# Determine output JSON filename
if [[ ${#YAML_FILES[@]} -eq 1 ]]; then
    OUTPUT_JSON="$(basename "${YAML_FILES[0]}" .yaml).json"
else
    OUTPUT_JSON="test_all.json"
fi

# Display configuration
echo "Mode: $([[ "$DRY_RUN" == true ]] && echo "Dry-run" || echo "Full")"
echo "Local: $([[ "$LOCAL" == true ]] && echo "Yes" || echo "No")"
echo "Files: ${YAML_FILES[*]}"
echo "Output: $OUTPUT_JSON"
echo ""

# Load test-planner
. ./tools/test-planner/load-test-planner

# Build optional flags
EXTRA_FLAGS=()
[[ "$LOCAL" == true ]] && EXTRA_FLAGS+=("--local")

# Execute
if [[ "$DRY_RUN" == true ]]; then
    "$test_planner_script" run --wake-build-option=--dry-run "${EXTRA_FLAGS[@]}" "${FILE_ARGS[@]}" -o "$OUTPUT_JSON"
else
    "$test_planner_script" run "${EXTRA_FLAGS[@]}" "${FILE_ARGS[@]}" -o "$OUTPUT_JSON"
fi
