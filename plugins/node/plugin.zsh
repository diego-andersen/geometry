# Color definitions
LOGIC_COLOR_PACKAGER_VERSION=${LOGIC_COLOR_PACKAGER_VERSION:-green}

# Symbol definitions
LOGIC_SYMBOL_PACKAGER_VERSION=${LOGIC_SYMBOL_PACKAGER_VERSION:-"⬡"}
LOGIC_NODE_PACKAGER_VERSION=$(prompt_logic_colorize $LOGIC_COLOR_PACKAGER_VERSION $LOGIC_SYMBOL_PACKAGER_VERSION) 

logic_prompt_node_setup() {
    (( $+commands[node] )) || (( $+commands[yarn] )) || return 1
}

logic_prompt_node_check() {
    test -f package.json || test -f yarn.lock || return 1
}

logic_prompt_node_render() {
    local LOGIC_NODE_DEFAULT_PACKAGE_MANAGER=npm

    if [[ $+commands[yarn] && -f yarn.lock ]]; then
        LOGIC_NODE_DEFAULT_PACKAGE_MANAGER=yarn
    fi

    LOGIC_PACKAGER_VERSION="$($LOGIC_NODE_DEFAULT_PACKAGE_MANAGER --version 2> /dev/null)" 
    LOGIC_NODE_VERSION="$(node -v 2> /dev/null)"
    echo "$LOGIC_NODE_PACKAGER_VERSION $LOGIC_NODE_VERSION ($LOGIC_NODE_DEFAULT_PACKAGE_MANAGER:$LOGIC_PACKAGER_VERSION)"
}
