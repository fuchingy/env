---
name: federation-build-run
description: Use this skill when you need to use federation to build design and run rtl simulation
---

# About federation

federation is SiFive private Git repository (https://github.com/sifive/federation). It contains the RTL design source code, testbench, and the test SW to be run on the design.

You can perform the following operations in this repository:
1. Build design
2. Build (compile) software
3. Run RTL simulation of the software on the design

## Setup New Federation Repository

Use the `setup_new_federation.sh` script to clone a fresh federation repository with proper cache reference and submodule initialization.

**Script Location**: `.augment/skills/federation-build-run/scripts/setup_new_federation.sh`

**Basic Usage**:
```bash
# Clone to default 'federation' directory with default branch
./.augment/skills/federation-build-run/scripts/setup_new_federation.sh

# Clone to custom directory
./.augment/skills/federation-build-run/scripts/setup_new_federation.sh my-federation

# Clone and checkout specific branch
./.augment/skills/federation-build-run/scripts/setup_new_federation.sh -b develop

# Clone to custom directory with specific branch
./.augment/skills/federation-build-run/scripts/setup_new_federation.sh -b release/v1.0 my-fed
```

## Run test-planner (metal)

在 specs/test-planner-plans/sim/sparta/perf-valid/ 目錄下，存放著performance team會跑的plan yaml檔案。每個 product sub-system 都會有自己的yaml檔案。
跑這些 yaml 檔的時候，就會把 design 編出來，並將在其上執行的軟體也編出來，最後執行 RTL simulation。

為了簡化 test-planner 的執行流程，可以使用 `run_plan_yaml.sh` script。這個 script 會自動處理環境載入、路徑設定以及執行流程。

**Script Location**: `.augment/skills/federation-build-run/scripts/run_plan_yaml.sh`

**Prerequisites**: 
- Must run from federation repository root directory
- YAML files must be in `specs/test-planner-plans/sim/sparta/perf-valid/` directory

**Common Usage Patterns**:

```bash
# List all available plan YAML files
./.augment/skills/federation-build-run/scripts/run_plan_yaml.sh --list

# Run single YAML file to generate plan JSON only (dry-run mode)
# This will generate design files but NOT run wake build.
# Output: pacific_sn1.json
./.augment/skills/federation-build-run/scripts/run_plan_yaml.sh -d pacific_sn1.yaml
# If the user wants to run wake build afterward, the command is
wake -v pacific_sn1.json

# Run single YAML file in full mode (generate plan JSON)
# Output: moray_sn2.json
./.augment/skills/federation-build-run/scripts/run_plan_yaml.sh moray_sn2.yaml

# Run multiple YAML files together
# Output: test_all.json
./.augment/skills/federation-build-run/scripts/run_plan_yaml.sh pacific_sn1.yaml moray_sn2.yaml yosemite_sn2.yaml
```

Important Notes:

* Script automatically loads test-planner environment (. ./tools/test-planner/load-test-planner)
* Only provide YAML filename (e.g., pacific_sn1.yaml), NOT the full path
* Dry-run mode (-d): Only runs test-planner run --wake-build-option=--dry-run, generates plan JSON but doesn't run wake build
* Full mode (default): Runs test-planner run to generate the plan JSON file
* Single YAML file: output JSON name matches input (e.g., pacific_sn1.yaml → pacific_sn1.json)
* Multiple YAML files: output JSON is always test_all.json
* After generating the plan JSON, you need to run wake -v build <output>.json separately to execute the build

When to Use Each Mode:

* Use --dry-run mode when you want to generate design files for inspection without running the full wake build
* Use full mode (no -d flag) when you want to generate the plan JSON for later wake build execution
* The --dry-run mode does NOT automatically run wake -v build - you must run it manually after the plan JSON is generated
