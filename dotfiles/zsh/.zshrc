# Shared zsh config - single source of truth across machines.
#
# This file is symlinked to ~/.zshrc on non-nix machines and sourced by Home
# Manager on nixos (see modules/home/cli/zsh.nix). As with nvim and tmux, this
# repo file is the single source of truth; the one difference is that Home
# Manager owns ~/.zshrc, so it sources this file rather than symlinking it.
# Plugins are managed here (git clone), not by Home Manager or Homebrew, so the
# interactive setup is identical everywhere. Keep it portable: guard anything
# machine-specific with a feature/command/file check.

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
# Homebrew (macOS): only if not already on PATH (login shells do this in
# ~/.zprofile). No-op on machines without brew.
if [[ -x /opt/homebrew/bin/brew && ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

typeset -U path
path=("$HOME/go/bin" "$HOME/.local/bin" $path)

# Rust toolchain installed via rustup (macOS); no-op elsewhere.
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# ---------------------------------------------------------------------------
# tmux: attach the 'default' session for interactive shells. Done before the
# heavier setup below so the outer shell hands off to tmux quickly; the shell
# inside the pane re-runs this file with $TMUX set and skips this block.
# ---------------------------------------------------------------------------
if [[ -o interactive && -z "$TMUX" ]] && (( $+commands[tmux] )); then
  if tmux has-session -t default 2>/dev/null; then
    tmux attach-session -t default
  else
    tmux new-session -s default
  fi
fi

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
mkdir -p "${HISTFILE:h}"
setopt HIST_IGNORE_DUPS    # ignoreDups
setopt HIST_IGNORE_SPACE   # ignoreSpace
setopt SHARE_HISTORY       # share
setopt EXTENDED_HISTORY    # extended

# ---------------------------------------------------------------------------
# Completion (skip if a parent already ran compinit, e.g. Home Manager)
# ---------------------------------------------------------------------------
if ! (( $+functions[compdef] )); then
  autoload -Uz compinit && compinit
fi

# ---------------------------------------------------------------------------
# Plugins: hand-rolled bootstrap. Clone on first run, then source.
# zsh-syntax-highlighting must be sourced last.
# ---------------------------------------------------------------------------
ZSH_PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

_zsh_load_plugin() {
  local name="$1" url="$2" file="$3"
  local dir="$ZSH_PLUGIN_DIR/$name"
  if [[ ! -e "$dir/$file" ]]; then
    (( $+commands[git] )) || { print -u2 "zsh: git missing, cannot install $name"; return 1; }
    print -P "%F{cyan}zsh: installing plugin $name%f"
    git clone --depth=1 "$url" "$dir" || return 1
  fi
  source "$dir/$file"
}

_zsh_load_plugin zsh-autosuggestions \
  https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions.zsh
_zsh_load_plugin zsh-syntax-highlighting \
  https://github.com/zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting.zsh

unfunction _zsh_load_plugin

# ---------------------------------------------------------------------------
# Tool integrations (each guarded so missing binaries are harmless)
# ---------------------------------------------------------------------------
(( $+commands[zoxide] ))   && eval "$(zoxide init zsh)"
(( $+commands[starship] )) && eval "$(starship init zsh)"
(( $+commands[fzf] ))      && source <(fzf --zsh)

# ---------------------------------------------------------------------------
# Keybindings
# ---------------------------------------------------------------------------
bindkey '^F' fzf-cd-widget

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
# Repo lives at ~/nixos-config on nixos and ~/.config/nixos-config on macOS.
for _nixconfig in "$HOME/.config/nixos-config" "$HOME/nixos-config"; do
  [[ -d "$_nixconfig" ]] && break
done

alias cd="z"
alias nixconfig="nvim $_nixconfig"
alias vimconfig="nvim $_nixconfig/dotfiles/nvim"
alias dt="ssh jesal@deepthought"
alias ls="eza"
alias l="eza -al"
alias ll="eza -al"
alias http="xh"
alias https="xhs"
alias cat="bat --paging=never"
alias ts="tms"
alias gg="jj"
alias g="jj"
alias j="jj"
alias oc="opencode"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
unset _nixconfig

# ---------------------------------------------------------------------------
# Yazi: cd to the last directory on exit
# ---------------------------------------------------------------------------
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  cwd="$(<"$tmp")"
  if [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ---------------------------------------------------------------------------
# Machine-specific overrides (not tracked in the repo)
# ---------------------------------------------------------------------------
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
