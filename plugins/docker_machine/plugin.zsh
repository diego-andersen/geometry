# Color definitions
LOGIC_COLOR_DOCKER_MACHINE=${LOGIC_COLOR_DOCKER_MACHINE:-blue}

# Symbol definitions
LOGIC_SYMBOL_DOCKER_MACHINE=${LOGIC_SYMBOL_DOCKER_MACHINE:-"⚓"}

logic_prompt_docker_machine_setup() {}

logic_prompt_docker_machine_check() {
  test -n $DOCKER_MACHINE_NAME || return 1
}

logic_prompt_docker_machine_render() {
  echo "$(prompt_logic_colorize $LOGIC_COLOR_DOCKER_MACHINE "(${LOGIC_SYMBOL_DOCKER_MACHINE} ${DOCKER_MACHINE_NAME})")"
}
