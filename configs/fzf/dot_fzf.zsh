# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/ajh/.fzf/bin* ]]; then
  export PATH="$PATH:/Users/ajh/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/ajh/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
if [ -f "/Users/ajh/.fzf/shell/key-bindings.zsh" ]; then
  source "/Users/ajh/.fzf/shell/key-bindings.zsh"
fi

function cdfzf() {
  # if no args, use '.'
  if (( $# == 0 )); then
    starting_paths="."
  else
    starting_paths=$argv
  fi

  chosen_path=$(find $starting_paths -type d -not -path '*/\.*' | fzf --height=20% --border --color)

  if [ $? -eq 0 ]; then
    cd $chosen_path
  else
    false
  fi
}
