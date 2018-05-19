# Load zsh/datetime module to be able to access `$EPOCHSECONDS`
zmodload zsh/datetime || return

# Flags
PROMPT_LOGIC_COMMAND_MAX_EXEC_TIME=${PROMPT_LOGIC_COMMAND_MAX_EXEC_TIME:-5}

typeset -g prompt_logic_command_timestamp
typeset -g prompt_logic_command_exec_time

# Stores (into prompt_logic_command_exec_time) the exec time of the last command if set threshold was exceeded
prompt_logic_check_command_exec_time() {
  integer elapsed
  # Default value for exec_time is an empty string (ie, it won't be rendered),
  # if we don't clear this up it may be rendered each time
  prompt_logic_command_exec_time=

  # Check if elapsed time is above the configured threshold
  (( elapsed = EPOCHSECONDS - ${prompt_logic_command_timestamp:-$EPOCHSECONDS} ))
  if (( elapsed > $PROMPT_LOGIC_COMMAND_MAX_EXEC_TIME )); then
    prompt_logic_command_exec_time="$(prompt_logic_seconds_to_human_time $elapsed)"
  fi

  # Clear timestamp after we're done calculating exec_time
  prompt_logic_command_timestamp=
}

prompt_logic_set_command_timestamp() {
  prompt_logic_command_timestamp=$EPOCHSECONDS
}

logic_prompt_exec_time_setup() {
  # Begin to track the EPOCHSECONDS since this command is executed
  add-zsh-hook preexec prompt_logic_set_command_timestamp
  # Check if we need to display execution time
  add-zsh-hook precmd prompt_logic_check_command_exec_time

  return true
}

logic_prompt_exec_time_check() {}

logic_prompt_exec_time_render() {
  echo "$prompt_logic_command_exec_time"
}
