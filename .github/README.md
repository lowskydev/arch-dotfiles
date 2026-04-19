# Dotfiles

Arch Linux dotfiles managed with a bare git repository.
Files stay in their exact locations, no symlinks, no special directories.

For a full list of required packages and post-install steps, see [PACKAGES.md](PACKAGES.md).

## Setup

The `dotfiles` alias replaces `git` for managing configs:
```
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Add this to your `~/.zshrc` then run `source ~/.zshrc`.

---

## Daily commands

```
dotfiles status          # what changed?
dotfiles ls-files        # what's tracked?
dotfiles log --oneline   # see history
dotfiles diff            # see exact changes
dst                      # alias for dotfiles status
dotpush 'msg'            # function for add -u -> commit -m 'msg' -> push
```

---

## Adding and updating configs

To track a new file or commit changes to an existing one:
```
dotfiles add ~/.config/someapp/config.conf
dotfiles commit -m "description"
dotfiles push
```

To stage all changes to already-tracked files at once:
```
dotfiles add -u
dotfiles commit -m "description"
dotfiles push
```

---

## Removing a config from tracking

Stop tracking but keep the file on disk:
```
dotfiles rm --cached ~/.config/someapp/config.conf
dotfiles commit -m "description"
dotfiles push
```

---

## Cloning to a new machine

```
# 1. Clone the bare repo
git clone --bare https://github.com/lowskydev/arch-dotfiles.git ~/.dotfiles

# 2. Add the alias temporarily
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# 3. Checkout your files
dotfiles checkout

# 4. Hide untracked files from status
dotfiles config --local status.showUntrackedFiles no

# 5. Source your zshrc (alias is now permanent)
source ~/.zshrc
```

> If checkout fails due to conflicts, back up the conflicting files first, then retry.

---

## What is not tracked

Anything that contains sensitive data, session state, or cache is intentionally excluded, including browser profiles, app data directories, undo history (`~/.config/nvim/undodir/`), SSH keys, and GPG keys.

---

## Quick reference

```
dotfiles status              # what changed?
dotfiles ls-files            # what's tracked?
dotfiles add -u              # stage all changes to tracked files
dotfiles add <file>          # start tracking a new file
dotfiles rm --cached <file>  # stop tracking a file (keep on disk)
dotfiles commit -m "msg"     # commit
dotfiles push                # push to GitHub
dotfiles pull                # pull changes from GitHub
dotfiles log --oneline       # see history
dotfiles diff                # see exact changes
dst                          # alias for dotfiles status
dotpush 'msg'                # function for add -u -> commit -m 'msg' -> push
```
