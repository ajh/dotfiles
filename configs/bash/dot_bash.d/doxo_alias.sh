# aspen
alias aspen-rebuild="rails-rebuild && aspen-restart && echo 'bundle exec rake ts:rebuild bin:apply_sample_documents bin:apply_sample_logos_to_providers' | sh -x"
alias aspen-restart="rails-restart && script/delayed_job stop && script/delayed_job start"

alias be="bundle exec"

# Can be used like: for i in $APP_PATHS; do echo $i done
APP_PATHS="/home/ajh/devel/aspen /home/ajh/devel/balsa /home/ajh/devel/cacao /home/ajh/devel/doha /home/ajh/devel/poui /home/ajh/devel/reverse_proxy /home/ajh/devel/saba /home/ajh/devel/snowbell"
