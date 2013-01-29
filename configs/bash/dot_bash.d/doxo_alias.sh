# aspen
alias aspen-rebuild="rails-rebuild && aspen-restart && echo 'bundle exec rake ts:rebuild bin:apply_sample_documents bin:apply_sample_logos_to_providers' | sh -x"
alias aspen-restart="rails-restart && script/delayed_job stop && script/delayed_job start"

alias be="bundle exec"
