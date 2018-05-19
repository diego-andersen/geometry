# Geometry
# Based on Avit and Pure
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
LOGIC_ROOT=${0:A:h}
source "$LOGIC_ROOT/lib/async.zsh"
source "$LOGIC_ROOT/lib/color.zsh"
source "$LOGIC_ROOT/lib/grep.zsh"
source "$LOGIC_ROOT/lib/plugin.zsh"
source "$LOGIC_ROOT/lib/time.zsh"
source "$LOGIC_ROOT/lib/title.zsh"

# Flags
PROMPT_LOGIC_SHOW_RPROMPT=${PROMPT_LOGIC_SHOW_RPROMPT:-true}
PROMPT_LOGIC_RPROMPT_ASYNC=${PROMPT_LOGIC_RPROMPT_ASYNC:-true}
PROMPT_LOGIC_ENABLE_PLUGINS=${PROMPT_LOGIC_ENABLE_PLUGINS:-true}
PROMPT_LOGIC_PRIMARY_SUFFIX=${PROMPT_LOGIC_PRIMARY_SUFFIX:-" "}

prompt_geometry_render() {
  PROMPT="$(geometry_plugin_render primary)$PROMPT_LOGIC_PRIMARY_SUFFIX"

  PROMPT2=" $LOGIC_SYMBOL_RPROMPT "

  if $PROMPT_LOGIC_SHOW_RPROMPT; then
    if $PROMPT_LOGIC_RPROMPT_ASYNC; then
        # On render we reset rprompt until async process
        # comes with newer git info
        RPROMPT=""
    else
        setopt localoptions no_prompt_subst
        RPROMPT="$(geometry_plugin_render secondary)"
    fi
  fi
}

prompt_geometry_setup() {
  zmodload zsh/datetime
  autoload -U add-zsh-hook

  if $PROMPT_LOGIC_ENABLE_PLUGINS; then
    geometry_plugin_setup
  fi

  # Helper functions from lib/title.zsh
  add-zsh-hook preexec prompt_geometry_set_cmd_title
  add-zsh-hook precmd prompt_geometry_set_title

  add-zsh-hook precmd prompt_geometry_render

  if $PROMPT_LOGIC_SHOW_RPROMPT && $PROMPT_LOGIC_RPROMPT_ASYNC; then
    geometry_async_setup
  fi
}

# Setup and initialize geometry
prompt_geometry_setup
