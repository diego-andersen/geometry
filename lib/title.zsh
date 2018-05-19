# Show current command in title
prompt_logic_set_cmd_title() {
  local COMMAND="${2}"
  local CURR_DIR="${PWD##*/}"
  setopt localoptions no_prompt_subst
  print -n '\e]0;'
  print -rn "$COMMAND @ $CURR_DIR"
  print -n '\a'
}

# Prevent command showing on title after ending
prompt_logic_set_title() {
  print -n '\e]0;'
  print -Pn '%~'
  print -n '\a'
}
