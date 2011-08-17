setxkbmap dvorak
#setxkbmap -layout us2 -variant dvorak
xset r rate 300 50
xset m 1 4
#xv -quit -root img/backgrounds/aerostream_black_800w.jpg
xsetroot -solid black
xset -b
xrandr --output TMDS-1 --below VGA
xset fp+ /home/steve/.fonts
xset fp rehash
#fluxbox
xgamma -gamma 0.95
#xmodmap -e 'remove Lock = Caps_Lock'
#xmodmap -e 'keysym Caps_Lock = Control_L'
#xmodmap -e 'add Control = Control_L'
#xbindkeys
xscreensaver &
#~/src/dzennotes.sh &
#~/common/src/sensorbar.sh &
#$awesome -c /usr/home/steve/.awesomerc
#/home/steve/bin/xmonad
#sh /home/steve/time.sh | dzen2 -fn '-*-helvetica-medium-r-*-*-10-*-*-*-*-*-*-*' -bg '#000000' -fg '#ffff66' -x 0 -w 100 -e '' &
xmodmap ~/.xmodmap
#exec ~/code/swim
#exec ~/bin/ratpoison
#exec evilwm
export WM="ratpoison"
case $WM in
	xmonad-dzen)
		Stats > dzenpipe &
	#	cat dzenpipe | tee /home/steve/tmp/dpipelog | dmplex | dzen2 -fn '-*-fixed-medium-r-*-*-6-*-*-*-*-*-*-*' -bg '#ffffff' -fg '#000000' -e 'onstart=raise;button1=raise' -ta r -h 5 -x 0 -w 80 &
		cat dzenpipe | tee /home/steve/tmp/dpipelog | dmplex | dzen2 -fn '-*-hlv-medium*' -bg '#dddddd' -fg '#333333' -e '' -ta l &
		echo "2 ^p(4)" > dzenpipe
		xmonad > dzenpipe
		#ratpoison
	;;
	xmonad)
		xset -b
		xmonad
	;;
	ratpoison)
		ratpoison | tee ~/ratpoison-messages
	;;
	ratpoison-lab)
		xrandr --output LVDS --mode 1280x800
		xrandr --output VGA --mode 1280x1024 --right-of LVDS
		ratpoison
	;;
	*)
		echo "arrrgh"
	;;
esac

#xmonad
#xfwm4
#ratpoison
#conky &
#pwm
#pekwm
#evilwm
