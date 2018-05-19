# Color definitions
LOGIC_COLOR_DOCKER_MACHINE=${LOGIC_COLOR_DOCKER_MACHINE:-blue}

# Symbol definitions
LOGIC_SYMBOL_DOCKER_MACHINE=${LOGIC_SYMBOL_DOCKER_MACHINE:-"⚓"}

geometry_prompt_docker_machine_setup() {}

geometry_prompt_docker_machine_check() {
  test -n $DOCKER_MACHINE_NAME || return 1
}

geometry_prompt_docker_machine_render() {
  echo "$(prompt_geometry_colorize $LOGIC_COLOR_DOCKER_MACHINE "(${LOGIC_SYMBOL_DOCKER_MACHINE} ${DOCKER_MACHINE_NAME})")"
}
