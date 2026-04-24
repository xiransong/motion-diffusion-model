# MyGO Integration Notes

This branch contains small local patches for using this MDM checkout as the reference implementation for the clean `mygo` restart.

## Scope

Keep patches narrow:

- make official MDM runnable against the clean `mygo_data` workspace
- avoid changing model, diffusion, training, or evaluation semantics unless a patch is explicitly documented
- prefer helper scripts over hidden path changes

## Workspace Assumption

Expected sibling layout:

```text
motion_workspace/
  mygo/
  mygo_data/
  third_party/
    motion-diffusion-model/
```

Clean HumanML3D copy:

```text
/home/ubuntu/scratch/repos/motion_workspace/mygo_data/datasets/humanml3d/raw/HumanML3D
```

MDM-specific assets, checkpoints, outputs, and generated caches live under:

```text
/home/ubuntu/scratch/repos/motion_workspace/mygo_data/projects/mdm
```

Official MDM expects these local paths:

```text
dataset/HumanML3D
glove
t2m
body_models/smpl
dataset/t2m_train.npy
```

Use the helper below to create local symlinks:

```bash
./prepare/mygo_link_workspace.sh
```

The symlinks are intentionally ignored by git.

## Environment

Use the project-owned micromamba environment from the `mygo` repo:

```bash
/home/ubuntu/scratch/micromamba/bin/micromamba run -n mygo-mdm python -m train.train_mdm --help
```

## Patch Log

- `prepare/mygo_link_workspace.sh`: link clean HumanML3D plus MDM-specific assets/cache/evaluators into the official paths.
- `model/mdm.py`: load CLIP ViT-B/32 from `mygo_data/projects/mdm/assets/text_encoders/clip` when available.
- `.gitignore`: ignore local dataset symlinks/copies and generated `dataset/t2m_*.npy` cache files.
