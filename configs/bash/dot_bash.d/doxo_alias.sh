# bundler
alias be="bundle exec"

# rails
alias rails-rebuild="echo 'bundle exec rake --trace db:drop db:create db:schema:load db:fixtures:load FIXTURES_PATH=spec/fixtures log:clear && rake db:test:prepare && rm -rf public/system/*' | bash -x"
alias rails-restart="touch tmp/restart.txt"

# aspen
alias aspen-rebuild="rails-rebuild && echo 'bundle exec rake --trace ts:rebuild bin:apply_sample_documents bin:apply_sample_logos_to_providers' | sh -x"

# Can be used like: for i in $APP_PATHS; do echo $i done
APP_PATHS="~/devel/aspen ~/devel/balsa ~/devel/cacao ~/devel/doha ~/devel/poui ~/devel/reverse_proxy ~/devel/saba ~/devel/snowbell"

alias cdpwd="cd $(pwd)" # useful when pwd is a symlink like /u/apps/app_name/current
