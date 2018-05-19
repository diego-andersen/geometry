# Color definitions
LOGIC_COLOR_PROMPT=${LOGIC_COLOR_PROMPT:-white}
LOGIC_COLOR_ROOT=${LOGIC_COLOR_ROOT:-red}
LOGIC_COLOR_DIR=${LOGIC_COLOR_DIR:-blue}
LOGIC_COLOR_EXIT_VALUE=${LOGIC_COLOR_EXIT_VALUE:-magenta}

# Symbol definitions
LOGIC_SYMBOL_RPROMPT=${LOGIC_SYMBOL_RPROMPT-"◇"}
LOGIC_SYMBOL_ROOT=${LOGIC_SYMBOL_ROOT-"▲"}
LOGIC_SYMBOL_PROMPT=${LOGIC_SYMBOL_PROMPT-"▲"}
LOGIC_SYMBOL_EXIT_VALUE=${LOGIC_SYMBOL_EXIT_VALUE-"△"}

# Misc configurations
LOGIC_PROMPT_PREFIX=${LOGIC_PROMPT_PREFIX-$'\n'}
LOGIC_PROMPT_PREFIX_SPACER=${LOGIC_PROMPT_PREFIX_SPACER-" "}

LOGIC_PROMPT_SUFFIX=${LOGIC_PROMPT_SUFFIX-""}
LOGIC_DIR_SPACER=${LOGIC_DIR_SPACER-""}
LOGIC_SYMBOL_SPACER=${LOGIC_SYMBOL_SPACER-" "}

LOGIC_PROMPT_PATH=${LOGIC_PROMPT_PATH:-"%3~"}
LOGIC_PROMPT_BASENAME=${LOGIC_PROMPT_BASENAME:-false}

PROMPT_LOGIC_COLORIZE_SYMBOL=${PROMPT_LOGIC_COLORIZE_SYMBOL:-false}
PROMPT_LOGIC_COLORIZE_ROOT=${PROMPT_LOGIC_COLORIZE_ROOT:-false}

# Helper function to colorize based off a string
prompt_logic_hash_color() {
  colors=(`seq 1 9`)

  if (($(echotc Co) == 256)); then
    colors+=(`seq 17 230`)
  fi

  local sum=0
  for i in {0..${#1}}; do
    ord=$(printf '%d' "'${1[$i]}")
    sum=$(($sum + $ord))
  done

  echo ${colors[$(($sum % ${#colors}))]}
}

logic_prompt_path_setup() {
  # Combine color and symbols
  LOGIC_EXIT_VALUE=$(prompt_logic_colorize $LOGIC_COLOR_EXIT_VALUE $LOGIC_SYMBOL_EXIT_VALUE)
  LOGIC_PROMPT=$(prompt_logic_colorize $LOGIC_COLOR_PROMPT $LOGIC_SYMBOL_PROMPT)

  if $PROMPT_LOGIC_COLORIZE_SYMBOL; then
    LOGIC_COLOR_PROMPT=$(prompt_logic_hash_color $HOST)
    LOGIC_PROMPT=$(prompt_logic_colorize $LOGIC_COLOR_PROMPT $LOGIC_SYMBOL_PROMPT)
  fi
}

logic_prompt_path_check() {}

logic_prompt_path_render() {
  if [ $? -eq 0 ] ; then
    PROMPT_SYMBOL=$LOGIC_SYMBOL_PROMPT
  else
    PROMPT_SYMBOL=$LOGIC_SYMBOL_EXIT_VALUE
  fi

  if $PROMPT_LOGIC_COLORIZE_ROOT && [[ $UID == 0 || $EUID == 0 ]]; then
    LOGIC_PROMPT=$(prompt_logic_colorize $LOGIC_COLOR_ROOT $LOGIC_SYMBOL_ROOT)
  fi

  local dir=$LOGIC_PROMPT_PATH
  if $LOGIC_PROMPT_BASENAME; then
    dir=$(basename $PWD)
  fi

  echo "$LOGIC_PROMPT_PREFIX$LOGIC_PROMPT_PREFIX_SPACER%${#PROMPT_SYMBOL}{%(?.$LOGIC_PROMPT.$LOGIC_EXIT_VALUE)%}$LOGIC_SYMBOL_SPACER%F{$LOGIC_COLOR_DIR}$dir%f$LOGIC_DIR_SPACER$LOGIC_PROMPT_SUFFIX"
}
