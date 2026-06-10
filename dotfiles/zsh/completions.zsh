# Tool completions, sourced from .zshrc after compinit. Generators cost
# 50-200ms each, so their output is cached and only regenerated when the
# tool's binary changes (newer mtime, or a new resolved path such as a nix
# store or Homebrew Cellar dir). Skipped for tools already covered via fpath.

(( $+functions[compdef] )) || return  # completion system not initialized

() {
  local -A generators=(
    jj      'env COMPLETE=zsh jj'
    gh      'gh completion -s zsh'
    helm    'helm completion zsh'
    rustup  'rustup completions zsh'
    uv      'uv generate-shell-completion zsh'
    kubectl 'kubectl completion zsh'
  )

  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"
  mkdir -p "$cache_dir"

  local cmd bin cache stamp out
  for cmd in ${(k)generators}; do
    (( $+commands[$cmd] )) || continue      # tool not installed
    [[ -n ${_comps[$cmd]} ]] && continue    # already provided via fpath
    bin="${commands[$cmd]:A}"
    cache="$cache_dir/$cmd.zsh"
    # The first line records which binary the cache was generated from.
    stamp="#stamp $bin"
    local first=''
    [[ -r "$cache" ]] && IFS= read -r first < "$cache"
    if [[ "$first" != "$stamp" || "$bin" -nt "$cache" ]]; then
      # Require non-empty output so a failed or silent generator can't write
      # a stamp-only cache that would never regenerate.
      if ! out="$(${=generators[$cmd]})" || [[ -z "$out" ]]; then
        print -u2 "zsh: completion generator for $cmd failed; skipping"
        continue
      fi
      # Temp file + rename so concurrent shells never source a partial cache.
      print -r -- "$stamp"$'\n'"$out" > "$cache.$$.tmp"
      mv -f "$cache.$$.tmp" "$cache"
    fi
    # Keep the .zwc fresh; sourcing loads wordcode instead of re-parsing.
    [[ "$cache.zwc" -nt "$cache" ]] || zcompile -U "$cache"
    source "$cache"
  done
}

# kubectl is aliased to kubecolor (and k to kubectl); zsh resolves the alias
# before completion lookup, so register kubectl's completion under those names.
[[ -n ${_comps[kubectl]} ]] && {
  compdef k=kubectl
  (( $+commands[kubecolor] )) && compdef kubecolor=kubectl
}
