######################################################################
#<
#
# Function: p6df::modules::shell::deps()
#
#>
######################################################################
p6df::modules::shell::deps() {
  ModuleDeps=(
    p6m7g8/p6shell
    ohmyzsh/ohmyzsh:plugins/encode64
    samoshkin/tmux-config
    #    junegunn/fzf
    #    lotabout/skim
  )
}

######################################################################
#<
#
# Function: p6df::modules::shell::vscodes()
#
#>
######################################################################
p6df::modules::shell::vscodes() {

  # shell
  brew install shfmt
  code --install-extension timonwong.shellcheck
  code --install-extension foxundermoon.shell-format
  code --install-extension jetmartin.bats
}

######################################################################
#<
#
# Function: p6df::modules::shell::external::brew()
#
#>
######################################################################
p6df::modules::shell::external::brew() {

  #  brew tap sbdchd/skim
  #  brew install skim

  brew install aspell
  brew install coreutils
  brew install parallel

  brew install shellcheck

  brew tap kaos/shell
  brew install bats-core
  brew install bats-file
  brew install bats-assert
  brew install bats-detik

  brew install jq
  brew install yq

  brew install recode

  brew install screen
  brew install tmux

  brew install tree

  brew install aria2
  brew install curl
  brew install wget
  brew install httpie
  brew install mtr

  brew install youtube-dl

  brew install xz

  brew install z

  brew install htop
  brew install lsof
  brew install bgrep
  brew install cgrep
  brew install grepcidr
  brew install ngrep
  brew install pgrep
  brew install pdfgrep
  brew install psgrep
  brew install ripgrep-all
}

######################################################################
#<
#
# Function: p6df::modules::shell::init()
#
#  Environment:	 P6_DFZ_SRC_DIR
#>
######################################################################
p6df::modules::shell::init() {

  # zgen load junegunn/fzf shell # completions
  # : prompt_opts+=(cr percent sp subst)

  # . $P6_DFZ_SRC_DIR/lotabout/skim/shell/key-bindings.zsh
  # . $P6_DFZ_SRC_DIR/lotabout/skim/shell/completion.zsh

  p6df::modules::shell::aliases::init
}

######################################################################
#<
#
# Function: p6df::modules::shell::aliases::init()
#
#  Environment:	 ESTABLISHED FGT LISTEN LSCOLORS NAME OSTYPE TCP TERM USER XXX
#>
######################################################################
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
  freebsd* | darwin*) alias ll='ls -alFGTh' ;;
  *) alias ll='/bin/ls -alFh --color=auto' ;;
  esac

  alias ssh_key_check=p6_ssh_key_check

  # XXX: not here
  zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
}

######################################################################
#<
#
# Function: p6df::modules::shell:replace(from, to)
#
#  Args:
#	from -
#	to -
#
#>
######################################################################
p6df::modules::shell:replace() {
  local from="$1"
  local to="$2"

  find . -type f |
    egrep -v '/.git/|/elpa/' |
    xargs grep -l $from |
    xargs perl -pi -e "s,$from,$to,g"
}

######################################################################
#<
#
# Function: p6df::modules::shell::proxy::prompt::line()
#
#  Depends:	 p6_proxy
#>
######################################################################
p6df::modules::shell::proxy::prompt::line() {

  p6_proxy_prompt_info
}

######################################################################
#<
#
# Function: str str = p6_proxy_prompt_info()
#
#  Returns:
#	str - str
#
#  Depends:	 p6_string
#  Environment:	 _PROXY
#>
######################################################################
p6_proxy_prompt_info() {

  local __p6_lf="
"
  local pair
  local str
  for pair in $(env | grep _PROXY=); do
    if p6_string_blank "$str"; then
      str="proxy:\t  $pair"
    else
      str=$(p6_string_append "$str" "proxy:\t  $pair" "$__p6_lf")
    fi
  done

  if ! p6_string_blank "$str"; then
    p6_return_str "$str"
  else
    p6_return_void
  fi
}

######################################################################
#<
#
# Function: p6df::modules::shell::proxy::off()
#
#  Environment:	 XXX
#>
######################################################################
p6df::modules::shell::proxy::off() {

  # XXX: move to lib
  local ev
  for ev in $(env | grep -i proxy=); do
    e=$(echo $ev | cut -f 1 -d =)
    echo $e
    unset $e
  done
}

######################################################################
#<
#
# Function: code rc = p6_shell_tmux_cmd(cmd, ...)
#
#  Args:
#	cmd -
#	... - 
#
#  Returns:
#	code - rc
#
#  Depends:	 p6_run
#>
######################################################################
p6_shell_tmux_cmd() {
  local cmd="$1"
  shift 1

  local log_type
  case $cmd in
  *) log_type=p6_run_write_cmd ;;
  esac

  p6_run_code "$log_type tmux $cmd $*"
  local rc=$?

  p6_return_code_as_code "$rc"
}

######################################################################
#<
#
# Function: p6df::modules::shell::tmux::new(session, cmd)
#
#  Args:
#	session -
#	cmd -
#
#>
######################################################################
p6df::modules::shell::tmux::new() {
  local session="$1"
  local cmd="$2"

  p6_shell_tmux_cmd "new -s \"$session\" $cmd"
}

######################################################################
#<
#
# Function: p6df::modules::shell::tmux::attach(session)
#
#  Args:
#	session -
#
#>
######################################################################
p6df::modules::shell::tmux::attach() {
  local session="$1"

  p6_shell_tmux_cmd "attach -d -t \"$session\""
}

######################################################################
#<
#
# Function: p6df::modules::shell::tmux::make(session, cmd)
#
#  Args:
#	session -
#	cmd -
#
#>
######################################################################
p6df::modules::shell::tmux::make() {
  local session="$1"
  local cmd="$2"

  p6df::modules::shell::tmux::attach "$session" ||
    p6df::modules::shell::tmux::new "$session" "$cmd"
}
