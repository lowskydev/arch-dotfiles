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

# Starship prompt
eval "$(starship init zsh)"
source ~/.zsh-transient-prompt/transient-prompt.zsh-theme
TRANSIENT_PROMPT_PROMPT='$(starship prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
TRANSIENT_PROMPT_RPROMPT='$(starship prompt --right --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
TRANSIENT_PROMPT_TRANSIENT_PROMPT='$(starship module character) '

# PATH
export PATH="$HOME/.local/bin:$PATH"
