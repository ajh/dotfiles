# nvm is installed via homebrew. Here are instructions:
#
# You should create NVM's working directory if it doesn't exist:
#
#   mkdir ~/.nvm
#
# Add the following to ~/.zshrc or your desired shell
# configuration file:
#
#   export NVM_DIR="$HOME/.nvm"
#   . "/usr/local/opt/nvm/nvm.sh"

if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
fi
if [ -f "/usr/local/opt/nvm/nvm.sh" ]; then
  . "/usr/local/opt/nvm/nvm.sh"
fi
