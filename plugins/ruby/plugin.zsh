# Color definitions
LOGIC_COLOR_RUBY_RVM_VERSION=${LOGIC_COLOR_PROMPT:-white}

LOGIC_RUBY_RVM_SHOW_GEMSET=${LOGIC_RUBY_RVM_SHOW_GEMSET:-true}

# Symbol definitions
LOGIC_SYMBOL_RUBY_RVM_VERSION=${LOGIC_SYMBOL_RUBY_RVM_VERSION:-"◆"}
LOGIC_RUBY_RVM_VERSION=$(prompt_geometry_colorize $LOGIC_COLOR_RUBY_RVM_VERSION $LOGIC_SYMBOL_RUBY_RVM_VERSION) 

prompt_geometry_get_full_ruby_version() {
  (( $+commands[ruby] )) && LOGIC_RUBY_VERSION_FULL="$(ruby -v)"
}

prompt_geometry_ruby_version() {
  [[ $LOGIC_RUBY_VERSION_FULL =~ 'ruby ([0-9a-zA-Z.]+)' ]]
  LOGIC_RUBY_VERSION=$match[1]
}

prompt_geometry_get_full_rvm_version() {
  (( $+commands[rvm] )) && LOGIC_RVM_VERSION_FULL="$(rvm -v)"
}

prompt_geometry_rvm_version() {
  [[ $LOGIC_RVM_VERSION_FULL =~ 'rvm ([0-9a-zA-Z.]+)'  ]]
  LOGIC_RVM_VERSION=$match[1]
}

geometry_prompt_ruby_setup() {
  (( $+commands[ruby] )) || return 1
}

geometry_prompt_ruby_check() {}

prompt_geometry_current_rvm_gemset_name() {
  if $LOGIC_RUBY_RVM_SHOW_GEMSET; then
      local cur_dir=$(pwd)
      local gemset_name=$(rvm current)
      [[ $gemset_name =~ 'ruby-[0-9.]+@?(.*)' ]]

      # If no name present, then it's the default gemset
      if [[ -z $match[1] ]]; then
          echo "default"
      else
          echo $match[1]
      fi
  fi
}

geometry_prompt_ruby_render() {
  prompt_geometry_get_full_ruby_version
  prompt_geometry_ruby_version

  local result="$LOGIC_RUBY_RVM_VERSION $LOGIC_RUBY_VERSION"

  if (( $+commands[rvm] )); then
      prompt_geometry_get_full_rvm_version
      prompt_geometry_rvm_version

      result=$result" ($LOGIC_RVM_VERSION"

      # Add current gemset name
      local rvm_gemset_name=$( prompt_geometry_current_rvm_gemset_name )
      if [[ ! -z $rvm_gemset_name ]]; then
          result=$result" $rvm_gemset_name"
      fi

      result=$result")"
  fi

  echo $result
}
