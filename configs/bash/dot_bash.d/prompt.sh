function ps1_git {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " … "${ref#refs/heads/}
}

function ps1_rvm {
  value=$(rvm-prompt i v g) || return # 1.9.3-p303@global
  echo " … "${value}
}

ps1="\[\e[0;32m\]"      # colored text
ps1=$ps1"\h"            # hostname
ps1=$ps1"\$(ps1_rvm)"   # 1.9.3@gemset
ps1=$ps1"\$(ps1_git)"   # git branch
ps1=$ps1" … \W"         # relative working dir
ps1=$ps1"\\n"           # new line
ps1=$ps1"\$"            # $
ps1=$ps1" "             # space
ps1=$ps1"\[\e[0m\]"     # reset color
export PS1=$ps1
