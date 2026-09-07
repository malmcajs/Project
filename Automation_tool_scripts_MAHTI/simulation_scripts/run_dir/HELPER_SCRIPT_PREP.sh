#!/bin/bash

cd ../..

BASE_DIR=${PWD}
SCRIPTS=${BASE_DIR}/simulation_scripts/run_dir
SNAKEFILE=${SCRIPTS}/run_prep_snake.sh

echo "Available systems:"
echo

SYSTEMS=()
num=1

while IFS= read -r dir; do
    [ -d "$dir" ] || continue

    system=$(basename "$dir")
    SYSTEMS+=("$system")
    echo "$num) $system"
    ((num++))
done < <(find "$BASE_DIR" -maxdepth 1 -type d -name "seq*" -print | sort -V)

echo
read -p "Select system: " choice

if ! [[ "$choice" =~ ^[0-9]+$ ]] || \
   [ "$choice" -lt 1 ] || \
   [ "$choice" -gt "${#SYSTEMS[@]}" ]; then
    echo "Invalid system selection."
    exit 1
fi

SYSTEM="${SYSTEMS[$((choice-1))]}"

# -------------------------
# Select project
# -------------------------

echo
echo "Available projects:"
echo

PROJECTS=()
num=1

your_projects=$(csc-projects | grep -o "project_.*" | awk '{print $1}')

for project in $your_projects; do
    PROJECTS+=("$project")
    echo "$num) $project"
    ((num++))
done

echo
read -p "Select project: " choice

if ! [[ "$choice" =~ ^[0-9]+$ ]] || \
   [ "$choice" -lt 1 ] || \
   [ "$choice" -gt "${#PROJECTS[@]}" ]; then
    echo "Invalid project selection."
    exit 1
fi

PROJECT="${PROJECTS[$((choice-1))]}"

# -------------------------
# Submit
# -------------------------

echo
echo "System:  $SYSTEM"
echo "Project: $PROJECT"
echo

sbatch --account="$PROJECT" "$SNAKEFILE" "$SYSTEM"
