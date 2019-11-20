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

# User specific aliases and functions
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
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

  local wan=$'\xe5\x8d\x8d'
# $BLUE[$RED\$(date +%H:%M)$BLUE]\
  PS1="${TITLEBAR}\
${BLUE}[$RED\u@\h:\W$GREEN\$(parse_git_branch)$BLUE]\
 $GREEN$wan$WHITE "
  PS2='> '
  PS4='+ '
}
proml

# refer to /usr/local/etc/privoxy/config
function use_proxy {
  export http_proxy='http://127.0.0.1:1087'
  export https_proxy='http://127.0.0.1:1087'
}

function close_proxy {
  unset http_proxy
  unset https_proxy
}

#ALTOOL=`find "/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/"  -iname altool`
function kube {
  kubectl --kubeconfig=$HOME/Dropbox/wansong.kubeconfig -n c-dev "$@"
}

function kubesim {
  kubectl --kubeconfig=$HOME/wansong-production.kubeconfig -n c-test "$@"
}

function kubeprod {
  kubectl --kubeconfig=$HOME/wansong-production.kubeconfig -n c-production "$@"
}


function start_virtual_python_env {
  python_exe=$1
  if [ ! -d "$HOME/.virtualenv" ] ;then
    mkdir "$HOME/.virtualenv"
  fi
  
  if [ ! -d "$HOME/.virtualenv/$python_exe" ] ;then
    virtualenv -p $python_exe "$HOME/.virtualenv/$python_exe"
  fi

  source "$HOME/.virtualenv/$python_exe/bin/activate"
}

function vpy3 {
  start_virtual_python_env python3
}

function kubesel {
  if [ $# -lt 1 ] ; then
    return 1
  elif [ $# -lt 2 ] ; then
    case "$1" in
      dev|sim|prod) true ;;
      *) echo "Bad args" ;  return 2
    esac
    local env=$1
    local pat=$(basename $(pwd))
  else
    local env=$1
    local pat=$2
  fi

  local lines
  case "$env" in
    dev) lines=$(kube get po | grep -E "$pat") ;;
    sim) lines=$(kubesim get po | grep -E "$pat") ;;
    prod) lines=$(kubeprod get po | grep -E "$pat") ;;
    *) echo "Bad args" ; return
  esac

  local IFSBack=$IFS
  IFS=$'\n'
  local lines=($lines)
  IFS=$IFSBack

  local pod=
  while [ -z "$pod" ] ; do
    echo "选择匹配的pod："
    select pod in "${lines[@]}" ; do
      if [ -n "$pod" ] ; then
        break
      fi
    done
  done

  local pod_fields=($pod)
  local pod=${pod_fields[0]}

  local cmds
  case "$env" in
    dev) cmds=("kube logs -f "'${pod}' "kube exec -it "'${pod}'" sh" "custom") ;;
    sim) cmds=("kubesim logs -f "'${pod}' "kubesim exec -it "'${pod}'" sh" "custom") ;;
    prod) cmds=("kubeprod logs -f "'${pod}' "kubeprod exec -it "'${pod}'" sh" "custom") ;;
  esac

  local cmd=
  while [ -z "$cmd" ] ; do
    echo "选择命令：1，2执行预置命令，选择3输入自定义命令。"
    select cmd in "${cmds[@]}"; do
      if [ -n "$cmd" ] ; then
        break
      fi
    done
    if [ "$cmd" = "custom" ] ; then
      echo '输入自定义命令，使用${pod}指代刚才选择的pod。'
      read cmd
    fi
    eval "$cmd"
  done
}

test -f ${HOME}/secrets/load.sh && . $_

# 一键打包所有本地重要文档
function packup() {
  # 当前用户的文档
  local user_profile=.bash_profile
  local gitconfig=.gitconfig
  local sshfiles=.ssh
  local local_only_dir=local-only/
  local my_archives=my-archives/
  local kubeconfig=kube.config
  local output_zip=packed.zip

  # 导出一些配置数据
  ls /Applications > "${my_archives}Applications.txt"
  zip -r "$output_zip" "$gitconfig" "$sshfiles" "$user_profile" "$local_only_dir" "$my_archives" "$kubeconfig"

  # 全局文档
  cd /
  zip -r ${HOME}/packed-system.zip \
    Library/LaunchDaemons/site.xway.privoxy.plist \
    Library/LaunchDaemons/demo.python.web.plist \
    usr/local/etc/privoxy/config
  cd - >/dev/null 2>&1
}

set -o vi

# 下载gitcompletion脚本
git_completion_bash="${HOME}/.git-completion.bash"
if [ ! -f $git_completion_bash ] ; then
  echo "Downloading config from github ..."
  curl -o $git_completion_bash -sL \
    'https://raw.githubusercontent.com/markgandolfo/git-bash-completion/master/git-completion.bash'
fi
test -f $git_completion_bash && source $_

export TERM="xterm-256color"

test -f /usr/local/etc/profile.d/autojump.sh && . $_

export PATH="${PATH}:${HOME}/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# config rbenv
export PATH="/Users/ws/.rbenv/shims:${PATH}"
export RBENV_SHELL=bash
if command -v rbenv >/dev/null ; then
  eval "$(rbenv init -)"
fi
rbenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}

REQUESTED_JAVA_VERSION='1.8'
if POSSIBLE_JAVA_HOME="$(/usr/libexec/java_home -v $REQUESTED_JAVA_VERSION 2>/dev/null)"; then
  # Do this if you want to export JAVA_HOME
  export JAVA_HOME="$POSSIBLE_JAVA_HOME"
  export PATH="${JAVA_HOME}/bin:${PATH}"
fi

export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
if [ -d "${ANDROID_SDK_ROOT}" ] ; then
  export ANDROID_HOME="$ANDROID_SDK_ROOT"
  export PATH=$PATH:${ANDROID_SDK_ROOT}/emulator
  export PATH=$PATH:${ANDROID_SDK_ROOT}/tools
  export PATH=$PATH:${ANDROID_SDK_ROOT}/tools/bin
  export PATH=$PATH:${ANDROID_SDK_ROOT}/platform-tools
else
  unset ANDROID_SDK_ROOT
fi

export HOMEBREW_NO_AUTO_UPDATE=1

# maybe will cause bad things?
#if [ -d "/usr/local/opt/llvm/bin" ] ; then
#  export PATH="/usr/local/opt/llvm/bin:$PATH"
#  export LDFLAGS="-L/usr/local/opt/llvm/lib"
#  export CPPFLAGS="-I/usr/local/opt/llvm/include"
#fi

# https://docs.brew.sh/Shell-Completion
HOMEBREW_PREFIX=$(brew --prefix)
if type brew &>/dev/null; then
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

# source .bash_profile.local for customization
test -r ~/.bash_profile.local && . ~/.bash_profile.local

export PATH=${HOME}/go/bin:$PATH

test -e ~/bin/goto_dir_of.sh && . $_

export VIM_SPECIFIED_CLANG='brew'
export NVIM_COC_LOG_LEVEL='debug'
