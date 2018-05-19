# Define how to colorize before the variables
prompt_logic_colorize() {
  echo "%F{$1}$2%f"
}

# alias prompt_logic_colorize as -g-color
-g-color() {
  prompt_logic_colorize "$@"
}
