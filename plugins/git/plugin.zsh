# Color definitions
LOGIC_COLOR_GIT_DIRTY=${LOGIC_COLOR_GIT_DIRTY:-red}
LOGIC_COLOR_GIT_CLEAN=${LOGIC_COLOR_GIT_CLEAN:-green}
LOGIC_COLOR_GIT_BARE=${LOGIC_COLOR_GIT_BARE:-blue}
LOGIC_COLOR_GIT_CONFLICTS_UNSOLVED=${LOGIC_COLOR_GIT_CONFLICTS_UNSOLVED:-red}
LOGIC_COLOR_GIT_CONFLICTS_SOLVED=${LOGIC_COLOR_GIT_CONFLICTS_SOLVED:-green}
LOGIC_COLOR_GIT_BRANCH=${LOGIC_COLOR_GIT_BRANCH:-242}
LOGIC_COLOR_GIT_STASHES=${LOGIC_COLOR_GIT_STASHES:-"144"}

# Symbol definitions
LOGIC_SYMBOL_GIT_DIRTY=${LOGIC_SYMBOL_GIT_DIRTY:-"⬡"}
LOGIC_SYMBOL_GIT_CLEAN=${LOGIC_SYMBOL_GIT_CLEAN:-"⬢"}
LOGIC_SYMBOL_GIT_BARE=${LOGIC_SYMBOL_GIT_BARE:-"⬢"}
LOGIC_SYMBOL_GIT_REBASE=${LOGIC_SYMBOL_GIT_REBASE:-"\uE0A0"}
LOGIC_SYMBOL_GIT_UNPULLED=${LOGIC_SYMBOL_GIT_UNPULLED:-"⇣"}
LOGIC_SYMBOL_GIT_UNPUSHED=${LOGIC_SYMBOL_GIT_UNPUSHED:-"⇡"}
LOGIC_SYMBOL_GIT_CONFLICTS_SOLVED=${LOGIC_SYMBOL_GIT_CONFLICTS_SOLVED:-"◆"}
LOGIC_SYMBOL_GIT_CONFLICTS_UNSOLVED=${LOGIC_SYMBOL_GIT_CONFLICTS_UNSOLVED:-"◈"}
LOGIC_SYMBOL_GIT_STASHES=${LOGIC_SYMBOL_GIT_STASHES:-"●"}

# Combine color and symbols
LOGIC_GIT_DIRTY=$(prompt_geometry_colorize $LOGIC_COLOR_GIT_DIRTY $LOGIC_SYMBOL_GIT_DIRTY)
LOGIC_GIT_CLEAN=$(prompt_geometry_colorize $LOGIC_COLOR_GIT_CLEAN $LOGIC_SYMBOL_GIT_CLEAN)
LOGIC_GIT_BARE=$(prompt_geometry_colorize $LOGIC_COLOR_GIT_BARE $LOGIC_SYMBOL_GIT_BARE)
LOGIC_GIT_STASHES=$(prompt_geometry_colorize $LOGIC_COLOR_GIT_STASHES $LOGIC_SYMBOL_GIT_STASHES)
LOGIC_GIT_REBASE=$LOGIC_SYMBOL_GIT_REBASE
LOGIC_GIT_UNPULLED=$LOGIC_SYMBOL_GIT_UNPULLED
LOGIC_GIT_UNPUSHED=$LOGIC_SYMBOL_GIT_UNPUSHED

# Flags
PROMPT_LOGIC_GIT_CONFLICTS=${PROMPT_LOGIC_GIT_CONFLICTS:-false}
PROMPT_LOGIC_GIT_TIME=${PROMPT_LOGIC_GIT_TIME:-true}
PROMPT_LOGIC_GIT_TIME_LONG_FORMAT=${PROMPT_LOGIC_GIT_TIME_LONG_FORMAT:-false}
PROMPT_LOGIC_GIT_TIME_SHOW_EMPTY=${PROMPT_LOGIC_GIT_TIME_SHOW_EMPTY:-true}
PROMPT_LOGIC_GIT_SHOW_STASHES=${PROMPT_LOGIC_GIT_SHOW_STASHES:-true}

# Misc configurations
LOGIC_GIT_NO_COMMITS_MESSAGE=${LOGIC_GIT_NO_COMMITS_MESSAGE:-"no commits"}
LOGIC_GIT_SEPARATOR=${LOGIC_GIT_SEPARATOR:-"::"}

prompt_geometry_git_time_since_commit() {
  # Defaults to "", which would hide the git_time_since_commit block
  local git_time_since_commit=""

  # Get the last commit.
  local last_commit=$(git log -1 --pretty=format:'%at' 2> /dev/null)
  if [[ -n $last_commit ]]; then
      now=$(date +%s)
      seconds_since_last_commit=$((now - last_commit))
      git_time_since_commit=$(prompt_geometry_seconds_to_human_time $seconds_since_last_commit $PROMPT_LOGIC_GIT_TIME_LONG_FORMAT)
  elif $PROMPT_LOGIC_GIT_TIME_SHOW_EMPTY; then
      git_time_since_commit=$(prompt_geometry_colorize $LOGIC_COLOR_NO_TIME $LOGIC_GIT_NO_COMMITS_MESSAGE)
  fi

  echo $git_time_since_commit
}

prompt_geometry_git_branch() {
  ref=$(git symbolic-ref --short HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "$(prompt_geometry_colorize $LOGIC_COLOR_GIT_BRANCH $ref)"
}

prompt_geometry_git_status() {
  if test -z "$(git status --porcelain --ignore-submodules HEAD)"; then
    if test -z "$(git ls-files --others --modified --exclude-standard)"; then
      echo $LOGIC_GIT_CLEAN
    else
      echo $LOGIC_GIT_DIRTY
    fi
  else
    echo $LOGIC_GIT_DIRTY
  fi
}

prompt_geometry_is_rebasing() {
  git_dir=$(git rev-parse --git-dir)
  test -d "$git_dir/rebase-merge" -o -d "$git_dir/rebase-apply"
}

prompt_geometry_git_rebase_check() {
  if $(prompt_geometry_is_rebasing); then
    echo "$LOGIC_GIT_REBASE"
  fi
}

prompt_geometry_git_remote_check() {
  local_commit=$(git rev-parse "@" 2>/dev/null)
  remote_commit=$(git rev-parse "@{u}" 2>/dev/null)

  if [[ $local_commit == "@" || $local_commit == $remote_commit ]]; then
    echo ""
  else
    common_base=$(git merge-base "@" "@{u}" 2>/dev/null) # last common commit
    if [[ $common_base == $remote_commit ]]; then
      echo $LOGIC_GIT_UNPUSHED
    elif [[ $common_base == $local_commit ]]; then
      echo $LOGIC_GIT_UNPULLED
    else
      echo "$LOGIC_GIT_UNPUSHED $LOGIC_GIT_UNPULLED"
    fi
  fi
}

prompt_geometry_git_symbol() {
  local render=""
  local git_rebase="$(prompt_geometry_git_rebase_check)"
  local git_remote="$(prompt_geometry_git_remote_check)"

  if [[ -n $git_rebase ]]; then
    render+="$git_rebase"
  fi

  if [[ -n $git_rebase && -n $git_remote ]]; then
    render+=" "
  fi

  if [[ -n $git_remote ]]; then
    render+="$git_remote"
  fi

  echo -n $render
}

prompt_geometry_git_conflicts() {
  conflicts=$(git diff --name-only --diff-filter=U)

  if [[ ! -z $conflicts ]]; then
    pushd -q $(git rev-parse --show-toplevel)
    conflict_list=$($LOGIC_GREP -cH '^=======$' $(echo $conflicts))
    popd -q

    raw_file_count=$(echo $conflict_list | cut -d ':' -f1 | wc -l)
    file_count=${raw_file_count##*( )}

    raw_total=$(echo $conflict_list | cut -d ':' -f2 | paste -sd+ - | bc)
    total=${raw_total##*(  )}

    if [[ -z $total ]]; then
      text=$LOGIC_SYMBOL_GIT_CONFLICTS_SOLVED
      color=$LOGIC_COLOR_GIT_CONFLICTS_SOLVED
    else
      text="$LOGIC_SYMBOL_GIT_CONFLICTS_UNSOLVED (${file_count}f|${total}c)"
      color=$LOGIC_COLOR_GIT_CONFLICTS_UNSOLVED
    fi

    echo "$(prompt_geometry_colorize $color $text) "
  else
    echo ""
  fi
}

geometry_prompt_git_setup() {
  (( $+commands[git] )) || return 1
}

geometry_prompt_git_check() {
  git rev-parse --git-dir > /dev/null 2>&1 || return 1
}

geometry_prompt_git_render() {
  # Check if we are in a bare repo
  if [[ $(command git rev-parse --is-inside-work-tree 2>/dev/null) == "false" ]] ; then
    echo -n "$LOGIC_GIT_BARE"
    return
  fi

  if $PROMPT_LOGIC_GIT_CONFLICTS ; then
    conflicts="$(prompt_geometry_git_conflicts)"
  fi

  if $PROMPT_LOGIC_GIT_TIME; then
    local git_time_since_commit=$(prompt_geometry_git_time_since_commit)
    if [[ -n $git_time_since_commit ]]; then
        time=" $git_time_since_commit $LOGIC_GIT_SEPARATOR"
    fi
  fi

  if $PROMPT_LOGIC_GIT_SHOW_STASHES && git rev-parse --quiet --verify refs/stash >/dev/null; then
      stashes=" $LOGIC_GIT_STASHES $LOGIC_GIT_SEPARATOR";
  fi

  local render="$(prompt_geometry_git_symbol)"

  if [[ -n $render ]]; then
    render+=" "
  fi

  render+="$(prompt_geometry_git_branch) ${conflicts}${LOGIC_GIT_SEPARATOR}${time}${stashes} $(prompt_geometry_git_status)"

  echo -n $render
}
