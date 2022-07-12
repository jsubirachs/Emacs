# variables varias
export PATH="$HOME/.local/bin:$PATH"
# packetes node locales
export PATH="$HOME/node_modules/.bin:$PATH"
alias larabash='sh ~/docker/laravel_project_shell.sh'
alias laraserv='sh ~/docker/laravel_server.sh'

# Load the default Guix profile
GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE"/etc/profile

# Make sure we can reach the GPG agent for SSH auth
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Start Shepherd to manage user daemons
if [ -z "$(pgrep -u over shepherd)" ]; then
  shepherd >/dev/null 2>&1
fi

# Make Flatpak apps visible to launcher
export XDG_DATA_DIRS="$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share"

# We're running Emacs server
export VISUAL=emacsclient
export EDITOR="$VISUAL"

# Load .bashrc to get login environment
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
