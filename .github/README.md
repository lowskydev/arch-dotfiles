# Dotfiles
Arch Linux (btw) dotfiles managed with a bare git repository - files stay in their exact locations, no symlinks needed.
See [PACKAGES.md](PACKAGES.md) for required packages and post-install steps.

---

## Alias
```
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
Use `dotfiles` as a drop-in replacement for `git` to manage configs.

---

## Clone to new machine
```
git clone --bare https://github.com/whywiki/arch-dotfiles.git ~/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
source ~/.zshrc
```

