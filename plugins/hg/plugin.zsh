LOGIC_COLOR_HG_DIRTY=${LOGIC_COLOR_HG_DIRTY:-red}
LOGIC_COLOR_HG_CLEAN=${LOGIC_COLOR_HG_CLEAN:-green}
LOGIC_COLOR_HG_BRANCH=${LOGIC_COLOR_HG_BRANCH:-242}

LOGIC_SYMBOL_HG_DIRTY=${LOGIC_SYMBOL_HG_DIRTY:-"⬡"}
LOGIC_SYMBOL_HG_CLEAN=${LOGIC_SYMBOL_HG_CLEAN:-"⬢"}
LOGIC_SYMBOL_HG_SEPARATOR=${LOGIC_SYMBOL_HG_SEPARATOR:-"::"}

LOGIC_HG_DIRTY=$(prompt_logic_colorize $LOGIC_COLOR_HG_DIRTY $LOGIC_SYMBOL_HG_DIRTY) 
LOGIC_HG_CLEAN=$(prompt_logic_colorize $LOGIC_COLOR_HG_CLEAN $LOGIC_SYMBOL_HG_CLEAN) 

logic_prompt_hg_branch() {
  local ref=$(hg branch 2> /dev/null) || return
  echo "$(prompt_logic_colorize $LOGIC_COLOR_HG_BRANCH $ref)"
}

# Checks if working tree is dirty
logic_prompt_hg_status() {
  if [[ -n $(hg status 2> /dev/null) ]]; then
    echo "$LOGIC_HG_DIRTY"
  else
    echo "$LOGIC_HG_CLEAN"
  fi
}

logic_prompt_hg_setup() {
  (( $+commands['hg'] )) || return 1
}

logic_prompt_hg_check() {
  test -d .hg || return 1
}

logic_prompt_hg_render() {
  echo "$(logic_prompt_hg_branch) ${LOGIC_SYMBOL_HG_SEPARATOR} $(logic_prompt_hg_status)"
}
