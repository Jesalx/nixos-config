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
# Environment
# ---------------------------------------------------------------------------
export EDITOR=nvim

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
# Shell options
# ---------------------------------------------------------------------------
setopt AUTO_CD              # bare directory name (e.g. `..`) chdirs into it
setopt AUTO_PUSHD           # cd pushes the old directory onto the dir stack
setopt PUSHD_IGNORE_DUPS    # keep the dir stack free of duplicates
setopt INTERACTIVE_COMMENTS # allow # comments on the command line (safe pastes)

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
  autoload -Uz compinit
  # A full compinit scan is slow: run it at most once a day, otherwise trust
  # the dump with -C. -i skips insecure (e.g. world-writable Homebrew) fpath
  # dirs instead of prompting. Delete the dump to refresh immediately.
  () {
    setopt local_options extended_glob
    local dump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
    mkdir -p "${dump:h}"
    if [[ -n "$dump"(#qN.mh-24) ]]; then
      compinit -C -d "$dump"
    else
      compinit -i -d "$dump"
      # compinit won't bump an unchanged dump's mtime; touch it so the daily
      # -C window restarts.
      [[ -f "$dump" ]] && touch "$dump"
    fi
  }
fi

# Smart-case completion: exact match first, then case-insensitive fallback.
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Tool completions, loaded after compinit so compdef is available.
_zsh_comp_file="${${(%):-%x}:A:h}/completions.zsh"
[[ -r "$_zsh_comp_file" ]] && source "$_zsh_comp_file"
unset _zsh_comp_file

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

# fzf-tab renders zsh's Tab completion menu through fzf. Must be sourced after
# compinit (above) and before plugins that wrap completion widgets (the two
# below); needs the fzf binary at runtime, so guard on it.
(( $+commands[fzf] )) && _zsh_load_plugin fzf-tab \
  https://github.com/Aloxaf/fzf-tab fzf-tab.plugin.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
_zsh_load_plugin zsh-autosuggestions \
  https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions.zsh
_zsh_load_plugin zsh-syntax-highlighting \
  https://github.com/zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting.zsh

unfunction _zsh_load_plugin

# ---------------------------------------------------------------------------
# fzf-tab styling (only meaningful when the plugin loaded above)
# ---------------------------------------------------------------------------
if (( $+commands[fzf] )); then
  # Let fzf-tab own the menu: stop the completion system drawing its own.
  zstyle ':completion:*' menu no
  # Group candidates under a header so fzf-tab can show/switch groups.
  zstyle ':completion:*:descriptions' format '[%d]'
  # Colourise file/dir candidates from LS_COLORS when it's set.
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  # Move between completion groups with < and >.
  zstyle ':fzf-tab:*' switch-group '<' '>'
  # Preview directory contents when completing cd. Guard eza as the file does
  # for its other optional tools.
  (( $+commands[eza] )) && \
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
fi

# ---------------------------------------------------------------------------
# Tool integrations (each guarded so missing binaries are harmless)
# ---------------------------------------------------------------------------
# zoxide owns cd (--cmd cd) and registers its own completion; `cdi` and
# `cd <space><tab>` open the interactive picker.
(( $+commands[zoxide] ))   && eval "$(zoxide init zsh --cmd cd)"
(( $+commands[starship] )) && eval "$(starship init zsh)"
(( $+commands[fzf] ))      && source <(fzf --zsh)
# atuin: record history (sync after `atuin login`). Keybindings disabled so the
# fzf widget below owns Ctrl-R and Up keeps zsh's default.
(( $+commands[atuin] ))    && eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"
# direnv: guard against a double hook if a parent already installed it (e.g.
# Home Manager's zsh integration on nixos), so this stays a no-op there.
(( $+commands[direnv] && ! $+functions[_direnv_hook] )) && eval "$(direnv hook zsh)"

# ---------------------------------------------------------------------------
# Keybindings
# ---------------------------------------------------------------------------
bindkey '^F' fzf-cd-widget

# Ctrl-R: fzf over atuin's history, overriding fzf's own $HISTFILE binding.
# Newest-first, deduped to the most recent; newline-delimited for awk portability.
if (( $+commands[atuin] && $+commands[fzf] )); then
  _atuin_fzf_history() {
    local selected
    selected=$(
      atuin history list --cmd-only --reverse false \
        | awk '!seen[$0]++' \
        | fzf --scheme=history --height 40% --reverse \
              --prompt 'history> ' --query "$LBUFFER"
    ) || return
    BUFFER="$selected"
    CURSOR=$#BUFFER
  }
  zle -N _atuin_fzf_history
  bindkey '^R' _atuin_fzf_history
fi

# Ctrl-E: fzf over env vars, inserting $NAME at the cursor (shadows end-of-line).
if (( $+commands[fzf] )); then
  _fzf_env_widget() {
    local selected
    selected=$(printenv | sort | fzf --height 40% --reverse --prompt 'env> ') || return
    LBUFFER+="\$${selected%%=*}"
    zle redisplay
  }
  zle -N _fzf_env_widget
  bindkey '^E' _fzf_env_widget
fi

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
# Repo lives at ~/nixos-config on nixos and ~/.config/nixos-config on macOS.
for _nixconfig in "$HOME/.config/nixos-config" "$HOME/nixos-config"; do
  [[ -d "$_nixconfig" ]] && break
done

# Named directories: ~dev and ~nix.
[[ -d "$HOME/Developer" ]] && hash -d dev="$HOME/Developer"
[[ -d "$_nixconfig" ]] && hash -d nix="$_nixconfig"

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

# kubernetes
alias k="kubectl"
# kube.fzf — interactive kubectl/context/namespace picker via fzf. Lives next to
# this file, resolved via a path relative to it (:A resolves symlinks) so it works
# whether ~/.zshrc is symlinked on non-nix machines or sourced by Home Manager.
# `kube` opens the menu (or takes a subcommand: p d j cj sc sn). It reimplements
# kubectx/kubens via plain kubectl, so kc/kn and the full kubectx/kubens names
# all route through it; pass a name (e.g. `kubens prod`) to switch directly, or
# omit it for the fzf picker. Falls back to the standalone tools only when fzf or
# the script isn't available.
_kube_fzf="${${(%):-%x}:A:h}/kube.fzf"
if [[ -x "$_kube_fzf" ]] && (( $+commands[fzf] )); then
  alias kube="'$_kube_fzf'"
  alias kc="'$_kube_fzf' sc"
  alias kn="'$_kube_fzf' sn"
  alias kubectx="'$_kube_fzf' sc"
  alias kubens="'$_kube_fzf' sn"
else
  (( $+commands[kubectx] )) && alias kc="kubectx"
  (( $+commands[kubens] ))  && alias kn="kubens"
fi
unset _kube_fzf
# colourised kubectl, only when kubecolor is installed (else kubectl would break)
(( $+commands[kubecolor] )) && alias kubectl="kubecolor"

# pr.fzf — interactive GitHub PR picker
_pr_fzf="${${(%):-%x}:A:h}/pr.fzf"
if [[ -x "$_pr_fzf" ]] && (( $+commands[fzf] && $+commands[gh] )); then
  alias pr="'$_pr_fzf'"
fi
unset _pr_fzf

# review.fzf — GitHub PRs awaiting your review (cross-repo)
_review_fzf="${${(%):-%x}:A:h}/review.fzf"
if [[ -x "$_review_fzf" ]] && (( $+commands[fzf] && $+commands[gh] )); then
  alias review="'$_review_fzf'"
fi
unset _review_fzf

# jj.fzf — interactive Jujutsu change/bookmark picker via fzf. Resolved the same
# way as kube.fzf above. `jf` opens the menu; `jjl`/`jjb` jump
# straight to the log/bookmark subcommands. The jj binary keeps its own aliases
# (j/jj/gg/g).
_jj_fzf="${${(%):-%x}:A:h}/jj.fzf"
if [[ -x "$_jj_fzf" ]] && (( $+commands[fzf] && $+commands[jj] )); then
  alias jf="'$_jj_fzf'"
  alias jjl="'$_jj_fzf' l"
  alias jjb="'$_jj_fzf' b"
fi
unset _jj_fzf

alias tf="terraform"
alias dev="cd ~/Developer"
# open the current directory in the OS file manager (macOS `open`, else xdg-open)
if (( $+commands[open] )); then
  alias ofd="open ."
elif (( $+commands[xdg-open] )); then
  alias ofd="xdg-open ."
fi
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
