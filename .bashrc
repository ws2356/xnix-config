# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000000
HISTFILESIZE=20000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

function proml {
local        BLUE="\[\033[0;34m\]"
local         RED="\[\033[0;31m\]"
local   LIGHT_RED="\[\033[1;31m\]"
local       GREEN="\[\033[0;32m\]"
local LIGHT_GREEN="\[\033[1;32m\]"
local       WHITE="\[\033[1;37m\]"
local  LIGHT_GRAY="\[\033[0;37m\]"
case $TERM in
    xterm*)
        TITLEBAR='\[\033]0;\u@\h:\w\007\]'

        ;;
    *)
        TITLEBAR=""
        ;;
esac

# $BLUE[$RED\$(date +%H:%M)$BLUE]\
PS1="${TITLEBAR}\
    $BLUE[$RED\u@\h:\w$GREEN\$(parse_git_branch)$BLUE]\
    $GREEN\$$WHITE "
PS2='> '
PS4='+ '
}
proml

export HISTSIZE=1000000
export HISTFILESIZE=$HISTSIZE

test -f ~/.git-completion.bash && . $_

