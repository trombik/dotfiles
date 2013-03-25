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

zstyle :compinstall filename '/home/sakurai/.zshrc'
fpath=(~/.zsh/functions/Completion ${fpath})
autoload -Uz compinit
compinit

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
HISTSIZE=3000
SAVEHIST=3000
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
        TERM="xterm"
        ;;
    FreeBSD)
        if [ -d /usr/local/libexec/ccache ]; then
            export PATH=/usr/local/libexec/ccache:$PATH
            export CCACHE_PATH=/usr/bin:/usr/local/bin
        fi
        USE_JP="LANG=ja_JP.UTF-8"
        ;;
    OpenBSD)
        export CVSROOT="anoncvs@anoncvs.jp.openbsd.org:/cvs"
        export PKG_PATH="http://ftp.openbsd.org/pub/OpenBSD/`uname -r`/packages/`machine -a`/:http://ftp.openbsd.org/pub/OpenBSD/`uname -r`/packages/`machine -a`/"
        if [ ! -z "${SSH_CONNECTION}" ]; then
            export TERM="xterm-color"
        fi
        USE_JP="LANG=ja_JP.eucJP"
        ;;
    *)
        ;;
esac

export LSCOLORS="Gxfxcxdxbxegedabagacad"
export FTP_PASSIVE_MODE="yes"
export TMP="$HOME/tmp"
if [ ! -d "$TMP" ]; then
    mkdir "$TMP"
fi

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
alias perlfunc="perldoc -f"
alias perlfaq="perldoc -q"
alias mkrandom="jot -r -c 16 A z | rs -g 0"
alias acroread="$USE_JP acroread"
alias kmail="$USE_JP kmail"
alias jurxvt="$USE_JP urxvt"
alias firefox="$USE_JP firefox"
alias irssi="jurxvt -name irssi -e irssi"
alias host="host -t any"
# git
alias ggs='git status'
alias ggd='git diff'
alias ggdc='git diff --cached'
alias ggb='git branch'
alias ggl='git log --name-status'
alias ggc='git checkout'

# }}}
# {{{ bindkey
# tcsh-like history search
bindkey -e
bindkey '^P' history-beginning-search-backward
bindkey '[A' history-beginning-search-backward
bindkey '[B' history-beginning-search-forward
# }}}
# {{{ functions
mytc() {
    sudo sh -c "cd /usr/local/tinderbox/scripts && ./tc $*"
}

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
ip() {
    dnsname $1
    rbl $1
    jwhois $1
    w3m -dump "http://www.senderbase.org/senderbase_queries/detailip?search_string=$1"
}
cpansearch() {
    Q="$@"
    Q=${Q//[[:space:]]##/+}
    w3m "http://search.cpan.org/search?mode=all&query=${Q}"
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

after_bootstrap() {
    chef_env="$1"; shift
    recipe="$1"; shift
    hosts=$*
    for host in $hosts; do
        echo $host
        /bin/echo knife node run_list remove "${host}" 'recipe[chef::bootstrap]'
        /bin/echo knife node set_environment "${host}" experimental
    done
}
# }}}
#PROMPT='%n@%{[36m%}%m%{[m%}:%~%(!.#.>) '
#RPROMPT='%{[32m%}%T%{[m%}'
#
# got this from:
# http://www.aperiodic.net/phil/prompt/
# http://www.aperiodic.net/phil/prompt/prompt.txt
function precmd {

    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))


    ###
    # Truncate the path if it's too long.
    
    PR_FILLBAR=""
    PR_PWDLEN=""
    
    local promptsize=${#${(%):---(%n@%M:%l)---()--}}
    local pwdsize=${#${(%):-%~}}
    
    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
	    ((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
	PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
    fi


}


setopt extended_glob
preexec () {
    if [[ "$TERM" == "screen" ]]; then
	local CMD=${1[(wr)^(*=*|sudo|-*)]}
	echo -n "\ek$CMD\e\\"
    fi
}


setprompt () {
    ###
    # Need this so the prompt will work.

    setopt prompt_subst


    ###
    # See if we can use colors.

    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"


    ###
    # See if we can use extended characters to look nicer.
    
    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    PR_HBAR=${altchar[q]:--}
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}

    
    ###
    # Decide if we need to set titlebar text.
    
    case $TERM in
	xterm*)
	    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
	    ;;
	screen)
	    PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
	    ;;
	*)
	    PR_TITLEBAR=''
	    ;;
    esac
    
    
    ###
    # Decide whether to set a screen title
    if [[ "$TERM" == "screen" ]]; then
	PR_STITLE=$'%{\ekzsh\e\\%}'
    else
	PR_STITLE=''
    fi
    
    
    
    ###
    # Finally, the prompt.

    PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_GREEN%(!.%SROOT%s.%n)$PR_GREEN@%M:%l\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_MAGENTA%$PR_PWDLEN<...<%~%<<\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\

$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
%(?..$PR_LIGHT_RED%?$PR_BLUE:)\
${(e)PR_APM}$PR_YELLOW%D{%H:%M}\
$PR_LIGHT_BLUE:%(!.$PR_RED.$PR_WHITE)%#$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOUR '

    RPROMPT=' $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
($PR_YELLOW%D{%a,%b%d}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'

    PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
}

setprompt

