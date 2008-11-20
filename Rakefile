desc "install all dotfiles"
task :install => ['install:vim', 'install:bash']

namespace :install do
  desc "install .vimrc and other vim configs"
  task :vim do
    ln_s_if_needed File.expand_path('vim/dot_vimrc'), "#{home}/.vimrc"
  end

  desc "install my bash settings"
  task :bash do
    mkdir_p "#{home}/.bash"
    ln_s_if_needed File.expand_path('bash/alias'), "#{home}/.bash/alias"
    puts " 
Insert the following in your .bashrc or .bash_profile:

if [ -f ~/.bash/alias ]; then
    . ~/.bash/alias
fi
"

  end
end

task :default => :install

def home
  ENV['HOME']
end

def ln_s_if_needed(src, dest)
  unless File.symlink?(dest) and File.readlink(dest) == src
    ln_s src, dest
  end
end
