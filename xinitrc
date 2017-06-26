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
export VISUAL=emacsclient
export EDITOR="$VISUAL"

# Changing pinky problem
xmodmap ~/.Xmodmap &
                  
# Start Emacs
exec dbus-launch --exit-with-session emacs
