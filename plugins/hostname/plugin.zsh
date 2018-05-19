LOGIC_PLUGIN_HOSTNAME_PREFIX=${LOGIC_PLUGIN_HOSTNAME_PREFIX:-"@ "}
LOGIC_PLUGIN_HOSTNAME_SUFFIX=${LOGIC_PLUGIN_HOSTNAME_SUFFIX:-""}

logic_prompt_hostname_setup() {}

logic_prompt_hostname_check() {
  [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
}

logic_prompt_hostname_render() {
  echo "$LOGIC_PLUGIN_HOSTNAME_PREFIX$(hostname)$LOGIC_PLUGIN_HOSTNAME_SUFFIX"
}
