# Virtualenv

You can display the current `virtualenv` or `conda` environment by enabling this plugin. Individual colors can be assigned to each of the two environments. If both are active at the same time they will be separated by `LOGIC_VIRTUALENV_CONDA_SEPARATOR`.


## Settings
Set these variables to change the appearance (with default values):
```bash
LOGIC_COLOR_VIRTUALENV=green           # Color for virtualenv environment name
LOGIC_COLOR_CONDA=green                # Color for conda environment name
LOGIC_VIRTUALENV_CONDA_SEPARATOR=:     # String that separates virtualenv and conda environment names if both are active
```

Change the displayed color by setting the `LOGIC_COLOR_PROMPT` environment
variable. Defaults to `green`.
