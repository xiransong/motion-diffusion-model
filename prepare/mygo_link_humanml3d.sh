#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." && pwd)
WORKSPACE_ROOT=$(cd -- "${REPO_ROOT}/../.." && pwd)

SRC=${MYGO_HUMANML3D_ROOT:-"${WORKSPACE_ROOT}/mygo_data/datasets/humanml3d/raw/HumanML3D"}
DST="${REPO_ROOT}/dataset/HumanML3D"

if [[ ! -d "${SRC}" ]]; then
  echo "HumanML3D source not found: ${SRC}" >&2
  echo "Set MYGO_HUMANML3D_ROOT to override the source path." >&2
  exit 1
fi

if [[ -L "${DST}" ]]; then
  current_target=$(readlink "${DST}")
  if [[ "${current_target}" == "${SRC}" ]]; then
    echo "Already linked: ${DST} -> ${SRC}"
    exit 0
  fi
  echo "Existing symlink points elsewhere: ${DST} -> ${current_target}" >&2
  exit 1
fi

if [[ -e "${DST}" ]]; then
  echo "Destination already exists and is not a symlink: ${DST}" >&2
  echo "Move it aside before linking." >&2
  exit 1
fi

ln -s "${SRC}" "${DST}"
echo "Linked: ${DST} -> ${SRC}"
