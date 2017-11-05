# {{{ PATH
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
if [ -L "/usr/X11R" ]; then
    :
else
	PATH=${PATH}:/usr/X11R/bin:/usr/X11R/sbin
fi
PATH=${PATH}:$HOME/bin
# }}}
# {{{ zsh

zstyle :compinstall filename "${HOME}/.zshrc"
fpath=(~/.zsh/functions/Completion ${fpath})
autoload -Uz compinit
compinit
autoload -U promptinit
promptinit

# auto quote URLs as command line arguments
autoload -U url-quote-magic
autoload history-search-end
zle -N self-insert url-quote-magic
setopt appendhistory autocd extendedglob nomatch notify
setopt listpacked auto_pushd correct noautoremoveslash nolistbeep
setopt hist_ignore_dups share_history complete_aliases nobeep
setopt ALWAYS_TO_END COMPLETE_IN_WORD EXTENDED_GLOB nohup
setopt magic_equal_subst mark_dirs pushd_ignore_dups auto_param_slash
setopt auto_param_keys 
# }}}
# {{{ variables
LISTMAX=256
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
export LANG=en_US.UTF-8
export XIM=ibus
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=xim
export XMODIFIERS=@im=ibus
export XIM_PROGRAM="ibus-daemon"
export XIM_ARGS="--daemonize --xim"

# cd /usr/local/etc/^W
# cd /usr/local/
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

OS=`uname -s`
case $OS in
    Linux)
        export LESSOPEN=""
        USE_JP="LANG=ja_JP.UTF8"
        export LS_COLORS="di=01;96"
        ;;
    FreeBSD)
        if [ -d /usr/local/libexec/ccache ]; then
            export PATH=/usr/local/libexec/ccache:$PATH
            export CCACHE_PATH=/usr/bin:/usr/local/bin
        fi
        USE_JP="LANG=ja_JP.UTF-8"
        export LSCOLORS="Gxfxcxdxbxegedabagacad"
        ;;
    OpenBSD)
        if [ ! -z "${SSH_CONNECTION}" ]; then
            export TERM="xterm-color"
        fi
        USE_JP="LANG=ja_JP.eucJP"
        ;;
    *)
        ;;
esac

export TMP="$HOME/tmp"
if [ ! -d "$TMP" ]; then
    mkdir "$TMP"
fi
chown ${USER} ${TMP}
chmod 700 ${TMP}

if [ -r "$(which vim)" -a -x "$(which vim)" ]; then
    export EDITOR=vim
else
    export EDITOR=vi
fi

# prefer less to more for PAGER
if [ -x $(which less) ]
then
    export PAGER="less -R"
    unalias less >& /dev/null
else
    alias less=more
fi

# }}}
# {{{ aliases
case $OS in
    Linux)
        alias ls='ls -F --color'
        alias ack="ack-grep"
        alias xlock="gnome-screensaver-command -l"
        ;;
    FreeBSD)
        alias ls='ls -G -F'
        ;;
    *)
        ;;
esac
alias la='ls -a'
alias h='history -50'
alias ll='ls -lA'
alias sx="startx -- -nolisten tcp"
alias j="job -l"
alias ducks="du -cks"
alias mkrandom="jot -r -c 16 A z | rs -g 0"
alias jurxvt="$USE_JP urxvt -fn '-*-lucidatypewriter-medium-*-*-*-12-*-*-*-*-*-iso8859-*,[codeset=JISX0208]-mplus-*-medium-*-*-*-12-*-*-*-*-*-jisx0208.1990-*'"
alias irssi="jurxvt -name irssi -e irssi"
alias host="host -t any"

# }}}
# {{{ bindkey
# tcsh-like history search
bindkey -e
bindkey '^P' history-beginning-search-backward
bindkey '[A' history-beginning-search-backward
bindkey '[B' history-beginning-search-forward
# }}}
# {{{ functions
buildworld10() {
    for i in 1 2 3 4 5 6 7 8 9 10; do
        NCORE=$( expr `sysctl kern.smp.cpus` * 2 )
        make -C /usr/src -j${NCORE} buildworld
    done
}

delcomment() {
    local file="$1"
    sed -e 's/#.*//' -e 's/^[[:space:]]*$//' "${file}" | grep '[[:print:]]'
}

google() {
    Q="$@"
    Q=${Q//[[:space:]]##/+}
    w3m "http://www.google.com/search?hl=en&q=$Q"
}
block2Mbyte() {
    BLOCK=$1
    print $(( $BLOCK * 512 / 1024 / 1024 ))
}

Bps2bps() {
    R=$1
    print $(( $R * 8 ))
}
KBps2Mbps() {
    R=$1
    print $(( $R * 1024 * 8 / 1024 / 1024 ))
}
BytesInMB() {
    perl -e "printf \"%.2f\\n\", $1 / (1024 * 1024)"
}
BytesInGB() {
    perl -e "printf \"%.2f\\n\", $1 / (1024 * 1024 * 1024)"
}
MBInBytes() {
    perl -e "printf \"%d\\n\", $1 * 1024 * 1024"
}
GBInBytes() {
    perl -e "printf \"%d\\n\", $1 * 1024 * 1024 * 1024"
}
# }}}
case $TERM in
	rxvt-256color|xterm*)
		prompt fade yellow black
		;;
	*)
		;;
esac

# source env-setup to use ansible from git repository
if [ -d ~/github/ansible ]; then
    source ~/github/ansible/hacking/env-setup -q
fi
