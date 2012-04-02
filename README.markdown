This project contains a chef-solo cookbook and related code to install
my dotfiles on the local machine.

How to install
==============
1. clone the git repo. I Normally clone to ~/.dotfiles
2. cd into the repro
3. install the rvm ruby and gemset
4. run bundler
5. run chef-solo like this: `chef-solo -c chef_config.rb -j chef.json`
