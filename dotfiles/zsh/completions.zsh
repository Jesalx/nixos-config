# Tool completions, sourced from .zshrc after compinit. Each command maps to a
# generator that prints a self-installing completion script, loaded only when the
# tool exists and isn't already provided via fpath.

(( $+functions[compdef] )) || return  # completion system not initialized

typeset -A _zsh_completions=(
  jj      'env COMPLETE=zsh jj'
  gh      'gh completion -s zsh'
  helm    'helm completion zsh'
  rustup  'rustup completions zsh'
  uv      'uv generate-shell-completion zsh'
  kubectl 'kubectl completion zsh'
)

for _cmd in ${(k)_zsh_completions}; do
  (( $+commands[$_cmd] )) || continue      # tool not installed
  [[ -n ${_comps[$_cmd]} ]] && continue    # already provided via fpath
  source <(${=_zsh_completions[$_cmd]})
done
unset _cmd _zsh_completions

# kubectl is aliased to kubecolor (and k to kubectl); zsh resolves the alias
# before completion lookup, so register kubectl's completion under those names.
[[ -n ${_comps[kubectl]} ]] && {
  compdef k=kubectl
  (( $+commands[kubecolor] )) && compdef kubecolor=kubectl
}

# cd is aliased to zoxide's `z` (see .zshrc), which ships no completion of its
# own, so zsh resolves the alias and falls back to completing files. Register
# cd's completion under `z` so `cd <tab>` offers directories like a real cd
# (and gives fzf-tab a directory context to preview).
(( $+commands[zoxide] )) && [[ -n ${_comps[cd]} ]] && compdef z=cd
