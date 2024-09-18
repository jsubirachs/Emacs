#!/bin/sh

# Must be executable (chmod +x)

# Source .profile for common environment vars
. ~/.profile

# Disable access control
xhost +SI:localuser:$USER

# Enable screen locking on suspend
# xss-lock -- slock &

# Turn off the system bell
xset -b

# Keyboard repeat rate
xset r rate 200 60

# Setting keyboard and changing pinky problem
# Not necessary in guix (include in config.scm)
# setxkbmap -model pc105 -layout es -option "ctrl:swapcaps" &
# Changing other keymaps and mouse
# Running from .emacs runs better
# xmodmap ~/.Xmodmap &

# Uncomment this to start xterm instead for debugging purposes!
# Then you can manually run the window manager and log output
# > exec dbus-launch emacs -mm --debug-init --use-exwm 2>&1 | tee ~/debug.log
#xterm
# exec ssh-agent dbus-launch --exit-with-session emacs -mm --debug-init --use-exwm
exec dbus-launch --exit-with-session emacs -mm --debug-init --use-exwm

