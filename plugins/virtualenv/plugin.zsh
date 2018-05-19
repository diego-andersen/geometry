# Color definitions
DEFAULT_COLOR=${LOGIC_COLOR_PROMPT:-green}
LOGIC_COLOR_VIRTUALENV=${LOGIC_COLOR_VIRTUALENV:-$DEFAULT_COLOR}
LOGIC_COLOR_CONDA=${LOGIC_COLOR_CONDA:-$DEFAULT_COLOR}
LOGIC_VIRTUALENV_CONDA_SEPARATOR=${LOGIC_VIRTUALENV_CONDA_SEPARATOR:-:}


logic_prompt_virtualenv_setup() {}

logic_prompt_virtualenv_check() {
    [ -n "${VIRTUAL_ENV}" -o -n "${CONDA_PREFIX}" ]
}

logic_prompt_virtualenv_render() {

    local environment_str=""

    # Add virtualenv name if active
    if [ -n "${VIRTUAL_ENV}" ]; then
        local virtualenv_ref=$(basename $VIRTUAL_ENV)
        environment_str="$(prompt_logic_colorize $LOGIC_COLOR_VIRTUALENV ${virtualenv_ref})"
    fi

    # Add separator if both active
    if [ -n "${VIRTUAL_ENV}" -a -n "${CONDA_PREFIX}" ]; then
        environment_str="${environment_str}${LOGIC_VIRTUALENV_CONDA_SEPARATOR}"
    fi

    # Add conda environment name if active
    if [ -n "${CONDA_PREFIX}" ]; then
        local conda_ref="$(basename $CONDA_PREFIX)"
        environment_str="${environment_str}$(prompt_logic_colorize $LOGIC_COLOR_CONDA ${conda_ref})"
    fi

    # Print to stdout
    echo "${environment_str}"

}
