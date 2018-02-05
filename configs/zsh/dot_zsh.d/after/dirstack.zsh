export DIRSTACKSIZE=1000
export MY_DIRSTACK_FILE=~/.zsh_dirstack

# load from file into $dirstack
if [[ -f $MY_DIRSTACK_FILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $MY_DIRSTACK_FILE)"} )
fi

# write to file on cd
function chpwd_dirstack() {
  print -l $PWD >> $MY_DIRSTACK_FILE
}

if [[ ${#chpwd_functions} -eq 0 || ! ${chpwd_functions[(i)chpwd_dirstack]} -le ${#chpwd_functions} ]]; then
  chpwd_functions=( chpwd_dirstack $chpwd_functions )
fi

# Running this makes my shell go crazy for some reason. But piping its output through cat seems to work, so I'll use that as a workaround.
function zshexit_dirstack_cleanup_path_filter() {
  while IFS='' read -r path; do
    if [[ -d $path ]]; then
      echo $path
    fi
  done
}

# organize MY_DIRSTACK_FILE on exit
function zshexit_dirstack_cleanup() {
  tempfile=$(mktemp)
  # TODO: it'd be better to truncate by frequency, not alphetically. sort -k 2
  # & uniq -c -f 1 almost do the job, but not quite
  sort -u $MY_DIRSTACK_FILE | head -n $DIRSTACKSIZE | zshexit_dirstack_cleanup_path_filter | cat > $tempfile
  mv $tempfile $MY_DIRSTACK_FILE
}

if [[ ${#zshexit_functions} -eq 0 || ! ${zshexit_functions[(i)zshexit_dirstack_cleanup]} -le ${#zshexit_functions} ]]; then
  zshexit_functions=( zshexit_dirstack_cleanup $zshexit_functions )
fi
