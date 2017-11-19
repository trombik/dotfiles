# vim: ft=sh
setxkbmap us
setxkbmap -option ctrl:nocaps
if [ -f "${HOME}/.Xresources.`hostname -s`" ]; then
    xrdb -merge -I"${HOME}" "${HOME}/.Xresources.`hostname -s`"
fi

urxvtd -q -f -o

if [ -x `which bmon 2>/dev/null` ]; then
    monitored_interfaces=""
    case `uname -s` in
        FreeBSD|OpenBSD)
            monitored_interfaces=`ifconfig -g wlan; ifconfig -g egress`
            ;;
        *)
            ;;
    esac
    bmon_flags="-b -o curses:gheight=4"
    if [ x"${monitored_interfaces}" == "x" ]; then
        :
    else
        for i in ${monitored_interfaces}; do
            bmon_flags="${bmon_flags} -p ${i}"
        done
    fi
    urxvtc -e bmon ${bmon_flags} &
fi

for i in `jot - 1 2`; do
    urxvtc &
done

awesome
