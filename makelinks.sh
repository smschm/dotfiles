#!/bin/zsh

for f in * .*; do
	if [[ $f != '.git' && $f != 'makelinks.sh' ]]; then
		mv ~/$f ~/$f~
		ln -s $PWD/$f ~/
	fi
done
