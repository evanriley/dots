#!/bin/sh

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
export DISPLAY=:0
export XDG_RUNTIME_DIR="/run/user/1000"

/usr/bin/emacsclient -e '(mu4e-update-index)'

# Send notification with sound
/usr/bin/notify-send -i /home/evan/mail.svg 'You have new mail'
/usr/bin/paplay /usr/share/sounds/freedesktop/stereo/message.oga
