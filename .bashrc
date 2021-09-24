#-----------
## Intended for interactive shell
## If not running interactively, don't do anything
#-----------
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
function use_proxy {
  export http_proxy='http://127.0.0.1:1087'
  export https_proxy='http://127.0.0.1:1087'
}

#-----------
## undo the effect of <@function use_proxy>
#-----------
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

#-----------
## call this to setup a virtual python 3 env(install if needed)
#-----------
function vpy3 {
  start_virtual_python_env python3
}

#-----------
## enabling select, interact with pod in a interactive way
## @param env
## @param pod_name_regex
#-----------
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
    ${HOMEBREW_PREFIX}/etc/privoxy/config
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

# maybe will cause bad things?
#if [ -d "${HOMEBREW_PREFIX}/opt/llvm/bin" ] ; then
#  path_prepend "${HOMEBREW_PREFIX}/opt/llvm/bin"
#  export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/llvm/lib"
#  export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/llvm/include"
#fi

# https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

javasel() {
  local -a brew_casks
  brew_casks=($(brew cask list))
  local -a jdk_versions
  for cask in "${brew_casks[@]}" ; do
    if [[ "$cask" =~ adoptopenjdk([[:digit:]]+) ]] ; then
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
  . ~/.bash_profile
}

swift() {
  local real_swift
  if real_swift=$(xcrun --toolchain swift --find swift 2>/dev/null) ; then
    "$real_swift" "$@"
  else
    command swift "$@"
  fi
}

# git cli
# git add -p时控制hunk大小
# export GIT_DIFF_OPTS=--unified=10

# default SDK_NAME
export SDK_NAME=macosx

# 快速切换目录
if [ -z "${CDPATH:-}" ] ; then
  CDPATH="."
fi

# shellcheck source=/dev/null
test -f "${HOME}/.bashrc.local" && \. "$_"

calc() {
  if [ "$#" -eq 0 ] ; then
    read -r expression
    calc "${expression:-1}"
    return
  fi
  echo "scale=6; ${1}" | bc
}

webproxy() {
  if [ $# -le 0 ] ;  then
    webproxy_
    return
  fi
  local onoff="${1:-on}"
  local port="${2:-8087}"
  local serv=
  {
    while { serv='' ; read -r serv || [ -n "$serv" ] ; } ; do
      if ! networksetup -getinfo "$serv" >/dev/null 2>&1 ; then
        continue
      fi
      if [ "$onoff" = "on" ] ; then
        sudo networksetup -setwebproxy "$serv" 127.0.0.1  "$port" ||  true
        sudo networksetup -setsecurewebproxy "$serv" 127.0.0.1  "$port" ||  true
      else
        sudo networksetup -setwebproxystate "$serv" "$onoff" ||  true
        sudo networksetup -setsecurewebproxystate "$serv" "$onoff" ||  true
      fi
    done
  } < <(networksetup -listallnetworkservices)
}

webproxy_() {
  local serv=
  {
    while { serv='' ; read -r serv || [ -n "$serv" ] ; } ; do
      if networksetup -getinfo "$serv" >/dev/null 2>&1 ; then
        echo "${serv}:"
        networksetup -getwebproxy "$serv" ||  true
        networksetup -getsecurewebproxy "$serv" ||  true
      fi
    done
  } < <(networksetup -listallnetworkservices)
}

pac() {
  local onoff="${1:-on}"
  local serv=
  {
    while { serv='' ; read -r serv || [ -n "$serv" ] ; } ; do
      if ! networksetup -getinfo "$serv" >/dev/null 2>&1 ; then
        continue
      fi
      if [ "$onoff" = "on" ] ; then
        sudo networksetup -setautoproxyurl "$serv" "http://127.0.0.1:8080/sso.pac" ||  true
      else
        sudo networksetup -setautoproxyurl "$serv" "" ||  true
      fi
    done
  } < <(networksetup -listallnetworkservices)
}

jwtinspect_base64_url_decode_prepare() {
  local cred="$1"
  cred="$(printf %s "$cred" | tr '-' '+' | tr '_' '/')"
  while [ $(( ${#cred} % 4 )) -ne 0 ] ; do
    cred="${cred}="
  done
  printf %s "$cred"
}

jwtinspect() {
  local header=
  local claims=
  local signature=
  local IFS_="$IFS"
  IFS='.' read -r header claims signature
  IFS="$IFS_"

  echo 'header:'
  jwtinspect_base64_url_decode_prepare "$header" | base64 -d | jq
  echo 'claims:'
  jwtinspect_base64_url_decode_prepare "$claims" | base64 -d | jq
  echo 'signature:'
  echo "$signature"
}

pf80() {
  sudo pfctl -ef - <<'EOF'

rdr pass inet proto tcp from any to any port 80 -> 127.0.0.1 port 8787
EOF
}

pf80off() {
  sudo pfctl -F all -f /etc/pf.conf
}

pfshow() {
  sudo pfctl -s nat
}

if GOPATH=$(go env GOPATH 2>/dev/null) ; then
  export GOPATH
  export PATH=$PATH:${GOPATH}/bin
  gosrc() {
    cd "${GOPATH}/src" || true
  }
  gobin() {
    cd "${GOPATH}/bin" || true
  }
  gohome() {
    cd "${GOPATH}" || true
  }
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
