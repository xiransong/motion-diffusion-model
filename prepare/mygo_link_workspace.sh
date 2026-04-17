#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." && pwd)
WORKSPACE_ROOT=$(cd -- "${REPO_ROOT}/../.." && pwd)
DATA_ROOT=${MYGO_DATA_ROOT:-"${WORKSPACE_ROOT}/mygo_data"}

link_path() {
  local src="$1"
  local dst="$2"
  local label="$3"

  if [[ ! -e "${src}" ]]; then
    echo "${label} source not found: ${src}" >&2
    exit 1
  fi

  if [[ -L "${dst}" ]]; then
    local current_target
    current_target=$(readlink "${dst}")
    if [[ "${current_target}" == "${src}" ]]; then
      echo "Already linked: ${dst} -> ${src}"
      return
    fi
    echo "Existing symlink points elsewhere: ${dst} -> ${current_target}" >&2
    exit 1
  fi

  if [[ -e "${dst}" ]]; then
    echo "Destination already exists and is not a symlink: ${dst}" >&2
    echo "Move it aside before linking." >&2
    exit 1
  fi

  mkdir -p "$(dirname "${dst}")"
  ln -s "${src}" "${dst}"
  echo "Linked: ${dst} -> ${src}"
}

link_path "${MYGO_HUMANML3D_ROOT:-"${DATA_ROOT}/datasets/humanml3d/raw/HumanML3D"}" \
  "${REPO_ROOT}/dataset/HumanML3D" \
  "HumanML3D"

link_path "${MYGO_MDM_GLOVE_ROOT:-"${DATA_ROOT}/projects/mdm/assets/word_vectors/glove"}" \
  "${REPO_ROOT}/glove" \
  "MDM GloVe"

link_path "${MYGO_MDM_SMPL_ROOT:-"${DATA_ROOT}/projects/mdm/assets/body_models/smpl"}" \
  "${REPO_ROOT}/body_models/smpl" \
  "MDM SMPL"

T2M_CACHE=${MYGO_MDM_T2M_TRAIN_CACHE:-"${DATA_ROOT}/projects/mdm/cache/datasets/t2m_train.npy"}
if [[ -e "${T2M_CACHE}" ]]; then
  link_path "${T2M_CACHE}" "${REPO_ROOT}/dataset/t2m_train.npy" "MDM HumanML3D train cache"
else
  echo "Optional MDM HumanML3D train cache not present: ${T2M_CACHE}"
fi
