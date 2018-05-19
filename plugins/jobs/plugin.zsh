# Color definitions
LOGIC_COLOR_JOBS=${LOGIC_COLOR_JOBS:-blue}

# Symbol definitions
LOGIC_SYMBOL_JOBS=${LOGIC_SYMBOL_JOBS:-"⚙"}

geometry_prompt_jobs_setup() {}

geometry_prompt_jobs_check() {
  [[ $(print -P '%j') == "0" ]]
}

geometry_prompt_jobs_render() {
  local jobs_prompt='%(1j.'$LOGIC_SYMBOL_JOBS' %j.)'
  echo $(prompt_geometry_colorize $LOGIC_COLOR_JOBS $jobs_prompt)
}
