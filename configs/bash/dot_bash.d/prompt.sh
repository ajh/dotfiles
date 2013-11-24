function ps1_git {
  local ref
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " … "${ref#refs/heads/}
}

function ps1_rvm {
  local value
  value=$(rvm-prompt i v g) || return # 1.9.3-p303@global
  echo " … "${value}
}

function ps1_time_of_day {
  local seconds_in_day=$[ \
    (`printf '%(%H)T' -1` * 60 * 60) + \
    (`printf '%(%M)T' -1` * 60) + \
    (10#`printf '%(%S)T' -1`) \
  ]
  local percent=`echo "scale=1; print ($seconds_in_day * 100) / (24 * 60 * 60)" | bc`
  local dow=`printf '%(%a)T' -1`
  echo " … "${dow}${percent}
}

PS1="\[\e[0;32m\]"      # colored text
PS1=$PS1"\h"                  # hostname
PS1=$PS1"\$(ps1_rvm)"         # 1.9.3@gemset
PS1=$PS1"\$(ps1_git)"         # git branch
PS1=$PS1" … \W"               # relative working dir
PS1=$PS1"\$(ps1_time_of_day)" # time of day
PS1=$PS1"\\n"                 # new line
PS1=$PS1"\$"                  # $
PS1=$PS1" "                   # space
PS1=$PS1"\[\e[0m\]"           # reset color
export PS1
