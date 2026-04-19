# Run hyprland if not running AND logged in in first virtual terminal (TT1)
if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec start-hyprland
fi

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Set LS_COLORS so completion menu colors match ls
eval "$(dircolors -b)"

# disable paste highlight box
zle_highlight=('paste:none')

# extra completion definitions
fpath=(/usr/share/zsh/site-functions $fpath)

# setopt globdots  # show dotfiles in completion

# Completion
autoload -Uz compinit && compinit                               # load zsh completion engine
zstyle ':completion:*' completer _complete _approximate         # complete then fuzzy-match typos, no history bleed
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'         # case insensitive matching
zstyle ':completion:*' list-suffixes yes                        # partial path: ~/d/ro -> ~/dev/robotics
zstyle ':completion:*' expand prefix suffix                     # expand each path segment separately
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"        # colors in menu matching ls colors
zstyle ':completion:*:descriptions' format '[%d]'              # show group headers and flag descriptions
zstyle ':completion:*' use-cache on                            # cache completions for speed
zstyle ':completion:*' cache-path ~/.zcompcache                # where to store the cache
zstyle ':completion:*' menu no                                 # let fzf-tab handle the menu, not zsh

# fzf-tab — replace completion menu with fzf picker
source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'  # tab accepts selection instead of enter
zstyle ':completion:*' list-dirs-first true # show directories first

# treat / as a word delimiter for CTRL+Left/Right navigation
WORDCHARS=${WORDCHARS/\/}

# Key bindings
typeset -g -A key
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Home]}"          ]] && bindkey -- "${key[Home]}"          beginning-of-line
[[ -n "${key[End]}"           ]] && bindkey -- "${key[End]}"           end-of-line
[[ -n "${key[Delete]}"        ]] && bindkey -- "${key[Delete]}"        delete-char
[[ -n "${key[Up]}"            ]] && bindkey -- "${key[Up]}"            up-line-or-history
[[ -n "${key[Down]}"          ]] && bindkey -- "${key[Down]}"          down-line-or-history
[[ -n "${key[Left]}"          ]] && bindkey -- "${key[Left]}"          backward-char
[[ -n "${key[Right]}"         ]] && bindkey -- "${key[Right]}"         forward-char
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf keybindings and completion
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# zoxide
eval "$(zoxide init zsh)"

# kitty SSH fix
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

# Git aliases
# most usefull: gst, gaa, gcm, gp, gl, glo, and gcb
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gbd='git branch -d'
alias gst='git status'
alias gss='git status -s'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias glo='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph --decorate --all'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grs='git restore'
alias grss='git restore --staged'
alias gsth='git stash'
alias gstp='git stash pop'

# Aliases
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias vim="nvim"
alias vi="nvim"
alias clear="tput reset"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dst='dotfiles status'

# Dotfiles quick commit and push
dotpush() {
  dotfiles add -u
  dotfiles commit -m "${1:?Usage: dotpush 'commit message'}"
  dotfiles push
}

# Fast syntax highlighting
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Starship prompt
eval "$(starship init zsh)"
source ~/.zsh-transient-prompt/transient-prompt.zsh-theme
TRANSIENT_PROMPT_PROMPT='$(starship prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
TRANSIENT_PROMPT_RPROMPT='$(starship prompt --right --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
TRANSIENT_PROMPT_TRANSIENT_PROMPT='$(starship module character) '


# PATH
export PATH="$HOME/.local/bin:$PATH"


