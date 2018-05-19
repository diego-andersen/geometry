# Choose best version of grep
prompt_logic_set_grep() {
  (command -v rg >/dev/null 2>&1 && echo "rg") \
  || (command -v ag >/dev/null 2>&1 && echo "ag") \
  || echo "grep"
}

LOGIC_GREP=${LOGIC_GREP:-$(prompt_logic_set_grep)}
