# dotfiles-installer

* install

	- nvim, zsh, util-linux-user, xorg-x11-server-utils, numlockx, alacritty, clang,
	  xmonad, xmobar, ghc-xmonad-contrib-devel,
	  node

* make directories

	- ~/Develop

	- ~/.config/python

	- ~/.bin

	- ~/.lib

	- ~/.hsts

	- ~/.zsh

```bash
$ sudo chmod 646 /etc/zshenv

$ wget --hsts-file=$WGETHISTFILE -O /etc/zshenv https://gist.githubusercontent.com/tobimd/9e9647a703872d0ee5aadd58adf4a77e/raw/c768e245820fd9a2bd2dc69cfce9884a66728953/zshenv

$ sudo chmod 644 /etc/zshenv
```

* touch/mv/rm files

```bash
$ wget --hsts-file=$WGETHISTFILE -O ~/.config/python/pythonrc https://gist.githubusercontent.com/tobimd/22dcb09bbd60ab31311b71f3b1dc6432/raw/4059ab672a26bbbc736bb5aecb3ed62aad145195/pythonrc

$ mv ~/.zshrc ~/.zsh_history ~/.zcompdump* ~/.zsh/

$ rm .lesshst
```

* install oh-my-zsh

```bash
$ export ZSH="$ZDOTDIR/.oh-my-zsh
$ zsh -c "$(wget --hsts-file=$WGETHISTFILE https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
$ mv -f ~/.zshrc $ZDOTDIR/.zshrc
```

* install typewritten (fork)

```bash
$ zsh -c "$(wget --hsts-file=$WGETHISTFILE https://raw.githubusercontent.com/tobimd/typewritten/main/scripts/install.sh -O -)"
```

* change shell for root

```bash
$ sudo -s

$ chsh -s /bin/zsh root
```
