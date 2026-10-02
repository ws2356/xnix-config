#-----------
## Intended for interactive shell
## If not running interactively, don't do anything
#-----------
case $- in
    *i*) ;;
      *) return;;
esac

# shellcheck source=/dev/null
test -f "${HOME}/.bashrc.local" && \. "$_"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000000
HISTFILESIZE=20000000

# 2. 忽略重复，实时同步
export HISTCONTROL=ignoredups:erasedups

# 核心：每次显示提示符（即敲回车后）都追加当前命令并重新读取历史文件
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# User specific aliases and functions
parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
ssh_server_name() {
  printf '%s' "${HOSTNAME_OVERRIDE:-}"
}
proml() {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local wan=$'\xf0\x9f\x90\x99'
  local server_name=$(ssh_server_name)

  if [ -n "$server_name" ] ; then
    PS1="${BLUE}[$RED\u@${server_name}:\W$GREEN\$(parse_git_branch)$BLUE]\
$GREEN$wan$WHITE "
  else
    PS1="${BLUE}[$RED\u@\h:\W$GREEN\$(parse_git_branch)$BLUE]\
$GREEN$wan$WHITE "
  fi
  PS2='> '
  PS4='+ '
}
proml


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


#-----------
## export two environmental variables: http_proxy, https_proxy for most other cli to use (automatically)
## refer to ${HOMEBREW_PREFIX}/etc/privoxy/config
#-----------
function proxy_on {
  local port="${1:-}"
  if [ -z "$port" ] ;  then
    echo "current: http_proxy: $http_proxy"
    return
  fi
  local host="${2:-localhost}"
  export http_proxy="http://${host}:${port}"
  export https_proxy=$http_proxy
}

#-----------
## undo the effect of <@function use_proxy>
#-----------
function proxy_off {
  unset http_proxy
  unset https_proxy
}

# 一键打包所有本地重要文档
packup() {
  # 当前用户的文档
  local -a default_input_files=(".bash_profile"
  ".gitconfig"
  ".ssh"
  "local-only/"
  "rsyncd.conf"
  "raspbian"
  )

  local -a filtered_list=()
  for ff in "${default_input_files[@]}" "$@" ; do
    if [ -e "$ff" ] ; then
      filtered_list+=("$ff")
    fi
  done

  if [ "${#filtered_list[@]}" -eq 0 ] ; then
    return
  fi

  local output_zip=packed.zip
  test -e "$output_zip" && rm "$_"

  zip -r "$output_zip" "${filtered_list[@]}"
}

set -o vi

export TERM="xterm-256color"

javasel() {
  local -a brew_casks
  brew_casks=($(brew list))
  local -a jdk_versions
  for cask in "${brew_casks[@]}" ; do
    if [[ "$cask" =~ openjdk([[:digit:]]+) ]] ; then
      jdk_versions+=("${BASH_REMATCH[1]}")
    elif [[ "$cask" =~ openjdk@([[:digit:]]+) ]] ; then
      jdk_versions+=("${BASH_REMATCH[1]}")
    fi
  done
  echo "Available jdks, choose one: ${jdk_versions[*]}"

  select version in "${jdk_versions[@]}" ; do
    if [ -n "$version" ] ; then
      break;
    fi
  done
  if [ -z "$version" ] ; then
    return 1
  fi
  if [ "$version" -lt 10 ] ; then
    version=1.${version}
  fi
  export USE_JDK_VERSION=${version}
  local this_dir=
  this_dir="$(get_containing_dir "${BASH_SOURCE[0]}")"
  test -f "${this_dir}/set_up_java.sh" && \. "$_"
}
# sudo locale-gen en_US.UTF-8
# export LC_ALL=en_GB.UTF-8

# git cli
# git add -p时控制hunk大小
# export GIT_DIFF_OPTS=--unified=10

calc() {
  if [ "$#" -eq 0 ] ; then
    read -r expression
    calc "${expression:-1}"
    return
  fi
  echo "scale=6; ${1}" | bc
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
