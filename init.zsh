p6df::modules::shell::version() { echo "0.0.1" }
p6df::modules::shell::deps()    { 
	ModuleDeps=()
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

irc () {
  if ! irc_attach ; then
    irc_init
  fi
}

p6df::modules::shell::init() {

  alias irc_attach='tmux attach -t irc'
  alias irc_init='tmux new -s irc irssi'

  export LSCOLORS=Gxfxcxdxbxegedabagacad
  case "$OSTYPE" in
        freebsd*|darwin*) alias ll='ls -alFGTh' ;;
                       *) alias ll='/bin/ls -alFh --color=auto' ;;
  esac
}

