# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  export PATH="$PATH:$HOME/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
if [ -f "$HOME/.fzf/shell/key-bindings.zsh" ]; then
  source "$HOME/.fzf/shell/key-bindings.zsh"
fi

function cdfzf() {
  # if no args, use '.'
  if (( $# == 0 )); then
    starting_paths="."
  else
    starting_paths=$argv
  fi

  chosen_path=$(find ${=starting_paths} -type d -not -path '*/\.*' | fzf --height=20% --color)

  if [ $? -eq 0 ]; then
    cd $chosen_path
  else
    false
  fi
}
