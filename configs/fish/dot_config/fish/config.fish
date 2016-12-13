fish_vi_key_bindings
set EDITOR vim

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'

# Neovim terminal mode hack
if test "$NVIM_LISTEN_ADDRESS" != ""
  set -u fish_term24bit
end

if [ -d $HOME/.config/fish/config.d ]
  for f in $HOME/.config/fish/config.d/*.fish
    source $f
  end
end

if [ -d $HOME/bin ]
  set PATH $HOME/bin $PATH
end
