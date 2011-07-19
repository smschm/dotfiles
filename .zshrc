# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
#zstyle :compinstall filename '/usr/home/steve/.zshrc'

autoload -Uz compinit
autoload colors
colors
compinit
# End of lines added by compinstall
#export GDK_USE_XFT=0
#export TERM=xterm-256color
export PAGER=most
alias caevnc="ssh -L 5900:localhost:5961"
alias h="ls -FG"
alias a="ls -FGrtl"
alias se="screen vim"
alias c="pushd"
alias T="tmux neww"
alias -g M="| less"
alias -g MM="|& less"
alias todo="cd ~/todo; vim todo"
alias td=hsgtd
alias bell="echo '\x07'"

#if [ x$WINDOW != x ]; then
#    HP="$WINDOW%# "
#else
#    HP='%# '
#fi

HEDR=rxvt
if [[ -n $TMUX ]]; then
	tmux rename-window -;
	HEDR=tmux
	#tmux setw utf8 on;
fi

case $HEDR in
	rxvt*)
		preexec() {
			print -Pn "\e]0;$1\a"
		}
		precmd() {
			#nowke=`ke`
			print -Pn "\e]0;%1~/\a"
		}
		HP='%# '
	;;
	tmux)
		preexec() {
			CMD=$1
			print -Pn "\ek$CMD[1,15]\e\\"
		}
		precmd() {
			#nowke=`ke`
			print -Pn "\ek[%1~]\e\\"
		}
		HP="$WINDOW%# "
	;;
	*)
		precmd() {
		#	export nowke=`ke`
		}
	;;
#xterm)
#	export TERM=xterm-color
#;;
esac

PATH="$PATH:$HOME/.cabal/bin"
case $HOST in
	hennessey)
		PC="" #${fg[green]}
		PATH="/usr/local/texlive/2010/bin/x86_64-linux:$PATH:/usr/local/texlive/2010/bin/i386-freebsd/"
	;;
	nixon)
		PC=${fg[blue]}
	;;
	hayward)
		PC="${HOST[(ws:.:)1]}:"
	;;
	etienne)
		PC="" #${fg[green]}
		alias tmux="tmux -2"
	;;
	ir*)
		PC="${fg[red]}${HOST[(ws:.:)1]}:"
		alias tmux="tmux -2"
		PATH="/usr/local/texlive/2010/bin/x86_64-linux:$PATH:/usr/local/texlive/2010/bin/i386-freebsd/"
	;;
	*)
		PC="${HOST[(ws:.:)1]}:"
		PATH="/usr/local/texlive/2010/bin/x86_64-linux:$PATH:/usr/local/texlive/2010/bin/i386-freebsd/"
	;;
esac

setopt PROMPT_SUBST
export PROMPT="${PC}%B%~
%b"
#export RPROMPT="%D{%d %h} %T [\$(ke)]"
export RPROMPT="%D{%d %h} %T"
export LSCOLORS="ExFxCxDxBxEGEDABAGACAD"
export EDITOR=vim
export LC_ALL="en_US.UTF-8" # bad on openbsd

function tmuxtitle() {
	a=${(V)1//\%/\%\%}
	print -Pn "\ek$a\e\\"
}
function xtermtitle() {
	print -Pn "\e]0;$1\a"
}


#function title() {
#  # escape '%' chars in $1, make nonprintables visible
#  a=${(V)1//\%/\%\%}
#
#  # Truncate command, and join lines.
#  a=$(print -Pn "%40>...>$a" | tr -d "\n")
#
#  case $TERM in
#  screen)
#    print -Pn "\ek$a:$3\e\\"      # screen title (in ^A")
#    ;;
#  xterm*|rxvt)
#    print -Pn "\e]2;$2 | $a:$3\a" # plain xterm title
#    ;;
#  esac
#}

function namedir() {
	eval $1=`pwd`
}

function wp() {
	surf "http://en.wikipedia.org/wiki/$1" &
}
function goog() {
	surf "http://google.com/search?q=$1" &
}
