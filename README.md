# dotfiles-installer

## install

#### General purpose
```bash
sudo dnf install neovim zsh util-linux-user xorg-x11-server-utils numlockx alacritty clang nodejs libatomic libcxx
sudo dnf group install "Development Tools"
```

#### Xmonad
```bash
sudo dnf install xmonad xmobar ghc-xmonad-contrib-devel
```

## Directories to create

- ~/Develop

- ~/.config/python

- ~/.bin

- ~/.lib

- ~/.hsts

- ~/.zsh

## Set global environment variables for zsh

```bash
sudo wget --hsts-file=~/.hsts/wget-hsts -O /etc/zshenv https://gist.githubusercontent.com/tobimd/9e9647a703872d0ee5aadd58adf4a77e/raw/c768e245820fd9a2bd2dc69cfce9884a66728953/zshenv
```

## Create, remove or move files

```bash
# Set new startup file for python under ~/.config/python/pythonrc.py
wget --hsts-file=$WGETHISTFILE -O ~/.config/python/pythonrc https://gist.githubusercontent.com/tobimd/22dcb09bbd60ab31311b71f3b1dc6432/raw/a200363ff4031d67a8fe337424b2fda0e1ef4a9c/pythonrc.py

# Move if possible any zsh-related files to the new directory ~/.zsh/
mv -f ~/.zshrc ~/.zsh_history ~/.zcompdump* ~/.zsh/

rm -f ~/.lesshst
```

## Install oh-my-zsh

```bash
# Set the ZSH environment variables
export ZDOTDIR="~/.zsh"
export ZSH="$ZDOTDIR/.oh-my-zsh"

zsh -c "$(wget --hsts-file=$WGETHISTFILE https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Move the created 
mv -f ~/.zshrc $ZDOTDIR/.zshrc
```

## Install typewritten (fork)

```bash
zsh -c "$(wget --hsts-file=$WGETHISTFILE https://raw.githubusercontent.com/tobimd/typewritten/main/scripts/install.sh -O -)"
```

## Install vim-plug
```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

## Change shell for root

```bash
sudo -s
chsh -s /bin/zsh root
```
