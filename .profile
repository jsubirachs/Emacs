# variables varias
export PATH="$HOME/.local/bin:$PATH"
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

# For fix ssh using gpg-agent
gpg-connect-agent updatestartuptty /bye 1>/dev/null

# We're running Emacs server
export VISUAL=emacsclient
export EDITOR="$VISUAL"

# Load .bashrc to get login environment
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
