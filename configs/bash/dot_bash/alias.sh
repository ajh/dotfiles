# file list 
alias la='ls -la'
alias less='less -R'
alias ll='ls -l'
alias ls='ls -G'

# subversion
alias nosvn='grep -v \.svn'
alias svn-add-new="svn st | grep '?' | tr -s ' ' | cut -d ' ' -f 2 | xargs svn add"
alias svn-diff='svn diff -x -w'
alias svn-grep="grep --exclude-dir='\.svn' --exclude-dir='\.git' --binary-files=without-match" # --exclude-dir requires grep 2.5.3
alias upst="echo '+ svn up' && svn up && echo '+ svn st' && svn st"

# rails
alias rails-grep="svn-grep --exclude-dir='public/system' --exclude-dir='tmp' --exclude='tags' --exclude='*.log'"
alias rails-rebuild="echo 'bundle exec rake db:reset db:seed db:fixtures:load FIXTURES_PATH=spec/fixtures log:clear && rm -rf public/system/* && bundle exec rake db:test:prepare' | sh -x"
alias rails-restart="touch tmp/restart.txt"
