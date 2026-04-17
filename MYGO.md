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

Official MDM expects:

```text
dataset/HumanML3D
```

Use the helper below to create a local symlink:

```bash
./prepare/mygo_link_humanml3d.sh
```

The symlink is intentionally ignored by git.

## Environment

Use the project-owned micromamba environment from the `mygo` repo:

```bash
/home/ubuntu/scratch/micromamba/bin/micromamba run -n mygo-mdm python -m train.train_mdm --help
```

## Patch Log

- `prepare/mygo_link_humanml3d.sh`: link the clean HumanML3D copy into `dataset/HumanML3D`.
- `.gitignore`: ignore local dataset symlinks/copies such as `dataset/HumanML3D`.
