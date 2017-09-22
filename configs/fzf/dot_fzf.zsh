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

# Configure Fzf
# ------------
if [ ! -f "$HOME/.fzf_history" ]; then
  touch "$HOME/.fzf_history"
fi
alias fzf="fzf --height=20% --min-height=5 --color --tiebreak=begin,length --history=$HOME/.fzf_history"

# fzf to cd into subdirectory
# ---------------------------
function cdt() {
  # if no args, use '.'
  if [[ (-z $1) || ($1 == "-h" ) ]]; then
    usage=$(<<USAGE
cdt - CDTree uses fzf to cd into subdirectories

Usage:

    $ cdt ~/code
    $ cdt ~/code query

In the first form with one argument, a fzf menu is opened to select a directory of the given directory. If a selection is made the current directory will be changed to it. In the second form fzf is started with the given query.

USAGE
)
    echo $usage
    false
    return
  fi

  if [ -z $2 ]; then
    fzf_args=""
  else
    fzf_args="--query=$2"
  fi

  choice=$(find $1 -type d -not -path '*/\.*' | fzf $fzf_args)

  if [ $? -eq 0 ]; then
    cd $choice
  else
    false
  fi
}

# fzf to cd into items on the dirstack
#
# Note: this could almost be an alias execpt passing they --query flag would be
# tedious.
# ------------------------------------
function cdr() {
  # if no args, use '.'
  if [[ $1 == "-h" ]]; then
    usage=$(<<USAGE
cdr - CDRecent uses fzf to cd into paths on the zsh dirstack

Usage:

    $ cdr
    $ cdr query

In the first form, a fzf menu is opened to select a directory on the dirstack, which is a list of recently visited directories. If a selection is made the current directory will be changed to it. In the second form fzf is started with the given query.

USAGE
)
    echo $usage
    return
  fi

  if [ -z $1 ]; then
    fzf_args=""
  else
    fzf_args="--query=$1"
  fi

  choice=$(cat $DIRSTACKFILE | fzf $fzf_args)

  if [ $? -eq 0 ]; then
    cd $choice
  else
    false
  fi
}
