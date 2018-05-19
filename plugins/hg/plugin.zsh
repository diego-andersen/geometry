LOGIC_COLOR_HG_DIRTY=${LOGIC_COLOR_HG_DIRTY:-red}
LOGIC_COLOR_HG_CLEAN=${LOGIC_COLOR_HG_CLEAN:-green}
LOGIC_COLOR_HG_BRANCH=${LOGIC_COLOR_HG_BRANCH:-242}

LOGIC_SYMBOL_HG_DIRTY=${LOGIC_SYMBOL_HG_DIRTY:-"⬡"}
LOGIC_SYMBOL_HG_CLEAN=${LOGIC_SYMBOL_HG_CLEAN:-"⬢"}
LOGIC_SYMBOL_HG_SEPARATOR=${LOGIC_SYMBOL_HG_SEPARATOR:-"::"}

LOGIC_HG_DIRTY=$(prompt_geometry_colorize $LOGIC_COLOR_HG_DIRTY $LOGIC_SYMBOL_HG_DIRTY) 
LOGIC_HG_CLEAN=$(prompt_geometry_colorize $LOGIC_COLOR_HG_CLEAN $LOGIC_SYMBOL_HG_CLEAN) 

geometry_prompt_hg_branch() {
  local ref=$(hg branch 2> /dev/null) || return
  echo "$(prompt_geometry_colorize $LOGIC_COLOR_HG_BRANCH $ref)"
}

# Checks if working tree is dirty
geometry_prompt_hg_status() {
  if [[ -n $(hg status 2> /dev/null) ]]; then
    echo "$LOGIC_HG_DIRTY"
  else
    echo "$LOGIC_HG_CLEAN"
  fi
}

geometry_prompt_hg_setup() {
  (( $+commands['hg'] )) || return 1
}

geometry_prompt_hg_check() {
  test -d .hg || return 1
}

geometry_prompt_hg_render() {
  echo "$(geometry_prompt_hg_branch) ${LOGIC_SYMBOL_HG_SEPARATOR} $(geometry_prompt_hg_status)"
}
