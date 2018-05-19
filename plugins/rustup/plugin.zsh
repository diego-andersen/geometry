# Color definitions
LOGIC_COLOR_RUSTUP_stable=${LOGIC_COLOR_RUSTUP_STABLE:-green}
LOGIC_COLOR_RUSTUP_beta=${LOGIC_COLOR_RUSTUP_BETA:-yellow}
LOGIC_COLOR_RUSTUP_nightly=${LOGIC_COLOR_RUSTUP_NIGHTLY:-red}

# Symbol definitions
LOGIC_SYMBOL_RUSTUP=${LOGIC_SYMBOL_RUSTUP:-"⚙"}

geometry_prompt_rustup_setup() {
  (( $+commands[rustup_prompt_helper] )) || return 1
}

geometry_prompt_rustup_check() {
    test -f Cargo.toml && return 0
     _git_dir=`git rev-parse --git-dir 2>/dev/null`
    test -f "${_git_dir/\.git/Cargo.toml}" && return 0
    return 1
}

geometry_prompt_rustup_render() {
    LOGIC_RUSTUP_TOOLCHAIN="$(rustup_prompt_helper 2> /dev/null)"
    LOGIC_COLOR_RUSTUP=${(e)LOGIC_RUSTUP_TOOLCHAIN:+\$LOGIC_COLOR_RUSTUP_${LOGIC_RUSTUP_TOOLCHAIN}}
    echo $(prompt_geometry_colorize $LOGIC_COLOR_RUSTUP $LOGIC_SYMBOL_RUSTUP)
}
