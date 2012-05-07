# file list
alias la='ls -la'
alias less='less -R'
alias ll='ls -l'
alias ls='ls -G'

# rails
alias rails-grep="grep --exclude-dir='public/system' --exclude-dir='tmp' --exclude='tags' --exclude='*.log'"
alias rails-rebuild="echo 'bundle exec rake db:reset db:seed db:fixtures:load FIXTURES_PATH=spec/fixtures log:clear && rm -rf public/system/* && bundle exec rake db:test:prepare' | sh -x"
alias rails-restart="touch tmp/restart.txt"
