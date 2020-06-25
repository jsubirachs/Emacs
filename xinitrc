# Disable access control
xhost +SI:localuser:$USER

# Themes, etc
# gnome-settings-daemon &

# Fallback cursor
xsetroot -cursor_name left_ptr

# Keyboard repeat rate
xset r rate 200 60

# If Emacs is started in server mode, `emacsclient` is a convenient way to edit
# files in place (used by e.g. `git commit`)
# Add env variables and PATH to the file ~/.login_conf
# export VISUAL=emacsclient
# export EDITOR="$VISUAL"

# Setting keyboard and changing pinky problem
setxkbmap -model pc105 -layout es -option "ctrl:swapcaps" &
# Changing other keymaps and mouse
# If run from .emacs runs better from beginning
# xmodmap ~/.Xmodmap &
                  
# Start Emacs
# check .xsession-errors if say something about machine-id and then run like root:
# root@pc:~# dbus-uuidgen > /var/lib/dbus/machine-id
exec dbus-launch --exit-with-session emacs
