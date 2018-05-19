LOGIC_PLUGIN_HOSTNAME_PREFIX=${LOGIC_PLUGIN_HOSTNAME_PREFIX:-"@ "}
LOGIC_PLUGIN_HOSTNAME_SUFFIX=${LOGIC_PLUGIN_HOSTNAME_SUFFIX:-""}

geometry_prompt_hostname_setup() {}

geometry_prompt_hostname_check() {
  [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
}

geometry_prompt_hostname_render() {
  echo "$LOGIC_PLUGIN_HOSTNAME_PREFIX$(hostname)$LOGIC_PLUGIN_HOSTNAME_SUFFIX"
}
