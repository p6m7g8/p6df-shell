p6df::modules::shell::version() { echo "0.0.1" }
p6df::modules::shell::deps()    {
	ModuleDeps=(robbyrussell/oh-my-zsh:plugins/encode64)
}

p6df::modules::shell::external::brew() {

  brew tap sbdchd/skim
  brew install skim

  brew install aspell
  brew install coreutils
  brew install curl
  brew install jq
  brew install screen
  brew install tmux
  brew install tree
  brew install wget
  brew install xz

  brew install irssi
  brew install youtube-dl
}

p6df::modules::shell::init() {

  alias '_'='sudo'
  alias rmrf='rm -rf'
  alias cpr='cp -R'
  alias mvf='mv -f'
  alias bclq='bc -lq'
  alias grepr='grep -R'

  alias j='jobs -l'
  alias h='history 25'
  alias duh='du -h'
  alias history='fc -l 1'

  alias 256color="export TERM=xterm-256color"
  alias prettyjson="python -mjson.tool"

  alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

  alias whichlinux='uname -a; cat /etc/*release; cat /etc/issue'

  alias flushdns='sudo dscacheutil -flushcache'
  alias whotunes='lsof -r 2 -n -P -F n -c iTunes -a -i TCP@`hostname`:3689'

  alias netstat='netstat -an -p tcp'
  alias listen='netstat -an -p tcp | grep LISTEN'
  alias listenu='netstat -an -p udp'
  alias established='netstat -an -p tcp | grep ESTABLISHED'

  alias tarx='tar -xvzof'
  alias tart='tar -tvzf'

  alias -g me="| grep $USER"
  alias -g ng='| grep -v "\.git"'
  alias -g n="| grep $NAME"

  alias irc_attach='tmux attach -t irc'
  alias irc_init='tmux new -s irc irssi'

  alias xclean p6_xclean

  export LSCOLORS=Gxfxcxdxbxegedabagacad
  case "$OSTYPE" in
	freebsd*|darwin*) alias ll='ls -alFGTh' ;;
		       *) alias ll='/bin/ls -alFh --color=auto' ;;
  esac
}

p6df::prompt::proxy::line() {

  if [ -n "${ALL_PROXY}" ]; then
      echo "${magenta}proxy: [ALL_PROXY=$ALL_PROXY]${norm}"
  fi
}

proxy_off() {

  local ev
  for ev in `env |grep -i ^proxy`; do
    e=$(echo $ev | cut -f 1 -d =)
    echo $e
    unset $e
  done
}

irc () {
  if ! irc_attach ; then
    irc_init
  fi
}

env_version() {
    local prefix="$1"

    local cmd="${prefix}env"
    local ver

    if command -v $cmd > /dev/null; then
        ver="$($cmd version-name 2>/dev/null)"

	local v=$(echo $ver | sed -e "s,$prefix,," -e 's,^-,,')

	if [ x"$v" = x"system" ]; then
	    system_version "$prefix"
	else
	    echo "$v"
	fi
    else
	system_version "$prefix"
    fi
}

cmd_2_envprefix() {
    local cmd="$1"

    local prefix
    case $cmd in
      python)	prefix=py    ;;
      ruby)     prefix=rb    ;;
      perl)     prefix=pl    ;;
      go)       prefix=go    ;;
      java)     prefix=j     ;;
      R)        prefix=R     ;;
      scala)    prefix=scala ;;
      lua)      prefix=lua   ;;
    esac

    echo $prefix
}

envprefix_2_cmd() {
    local prefix="$1"

    local rcmd
    case $prefix in
	py)    rcmd=python ;;
	rb)    rcmd=ruby   ;;
	pl)    rcmd=perl   ;;
	go)    rcmd=go     ;;
	j)     rcmd=java   ;;
	R)     rcmd=R      ;;
	scala) rcmd=scala  ;;
	lua)   rcmd=lua    ;;
    esac

    echo $rcmd
}

system_version() {
    local prefix="$1"

    local rcmd=$(envprefix_2_cmd "$prefix")

    if command -v $rcmd > /dev/null; then
	local ver
	case $prefix in
	    py)    ver=$($rcmd -V 2>&1 | awk '{print $2}') ;;
	    rb)    ver=$($rcmd -v | awk '{print $2}')      ;;
	    pl)    ver=$($rcmd -v | sed -e 's,.*(,,' -e 's,).*,,' | grep ^v5 | sed -e 's,^v,,') ;;
	    go)    ver=$($rcmd version | awk '{print $3}' | sed -e 's,^go,,') ;;
	    j)     ver=$($rcmd -version 2>&1 | grep Environment | sed -e 's,.*(build ,,' -e 's,).*,,') ;;
	    R)     ver=$($rcmd --version | awk '/ version / { print $3}') ;;
	    scala) ver=$($rcmd -nc -version 2>&1 | awk '{print $5}') ;;
	    lua)   ver=$($rcmd -v | awk '{print $2}') ;;
	esac
	echo "sys@$ver"
    else
	echo "no"
    fi
}

mtime() {
    local file="$1"

    command stat -f "%m" $file
}

now() {

    date "+%s"
}

p6df::modules::shell::init
