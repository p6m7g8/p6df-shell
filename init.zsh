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
  brew install yq
  brew install screen
  brew install tmux
  brew install tree
  brew install wget
  brew install xz

  brew install youtube-dl
}

p6df::modules::shell::home::symlink() {

  # XXX: TODO
}

p6df::modules::shell::init() {

  p6df::modules::shell::aliases::init
}

p6df::modules::shell::aliases::init() {

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

  alias pssh='p6_remote_ssh_do'

  alias xclean='p6_xclean'
  alias replace='p6df::modules::shell:replace'
  alias proxy_off='p6df::modules::shell::proxy::off'

  export LSCOLORS=Gxfxcxdxbxegedabagacad
  case "$OSTYPE" in
	freebsd*|darwin*) alias ll='ls -alFGTh' ;;
		       *) alias ll='/bin/ls -alFh --color=auto' ;;
  esac

  # XXX: not here
  zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
}

p6df::modules::shell:replace() {
    local from="$1"
    local to="$2"

    find . -type f | \
	egrep -v '/.git/|/elpa/' | \
	xargs grep -l $from | \
	xargs perl -pi -e "s,$from,$to,g"
}

p6df::prompt::proxy::line() {

  if [ -n "${ALL_PROXY}" ]; then
    echo "proxy:\tALL_PROXY=$ALL_PROXY"
  fi
}

p6df::modules::shell::proxy::off() {

  # XXX: move to lib
  local ev
  for ev in `env |grep -i ^proxy`; do
    e=$(echo $ev | cut -f 1 -d =)
    echo $e
    unset $e
  done
}
