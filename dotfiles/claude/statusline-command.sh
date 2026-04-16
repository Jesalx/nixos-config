#!/bin/sh

input=$(cat)

eval "$(echo "$input" | jq -r '
  @sh "cwd=\(.cwd // empty)",
  @sh "model=\(.model.display_name // empty)",
  @sh "ctx_pct=\(.context_window.used_percentage // empty | round)",
  @sh "five_hr_pct=\(.rate_limits.five_hour.used_percentage // empty | round)",
  @sh "resets_at=\(.rate_limits.five_hour.resets_at // empty)",
  @sh "transcript_path=\(.transcript_path // empty)"
')"

tok_in=0
tok_out=0
cache_pct=""
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
    totals=$(jq -rs '
      [.[] | select(.message.usage and .requestId) | {r: .requestId, u: .message.usage}]
      | unique_by(.r)
      | map(.u)
      | {
          input: (map(.input_tokens + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)) | add // 0),
          output: (map(.output_tokens) | add // 0),
          cache_read: (map(.cache_read_input_tokens // 0) | add // 0)
        }
      | "\(.input) \(.output) \(if .input > 0 then (.cache_read * 100 / .input | floor) else "" end)"
    ' "$transcript_path" 2>/dev/null)
    if [ -n "$totals" ]; then
        set -- $totals
        tok_in=$1
        tok_out=$2
        cache_pct=$3
    fi
fi

abbrev() {
    awk -v n="${1:-0}" 'BEGIN {
        if (n+0 == 0) { exit }
        if (n >= 1000000) {
            v = n/1000000
            if (v >= 10) printf "%dM", v+0.5
            else printf "%.1fM", v
        } else if (n >= 1000) {
            v = n/1000
            if (v >= 10) printf "%dk", v+0.5
            else printf "%.1fk", v
        } else {
            printf "%d", n
        }
    }'
}

work_dir="${cwd:-$(pwd)}"
printf "\033[1;34m%s\033[0m" "$(basename "$work_dir")"

if git -C "$work_dir" rev-parse --git-dir > /dev/null 2>&1; then
    staged=0 modified=0 untracked=0
    while IFS= read -r line; do
        case "$line" in
            [MADRC]" "*)  staged=$((staged + 1)) ;;
            " "[MADRC]*)  modified=$((modified + 1)) ;;
            "?"*)         untracked=$((untracked + 1)) ;;
        esac
        case "$line" in
            [MADRC][MADRC]*) modified=$((modified + 1)) ;;
        esac
    done <<EOF
$(git -C "$work_dir" status --porcelain 2>/dev/null)
EOF

    parts=""
    [ "$staged" -gt 0 ]    && parts="${parts}${staged}+ "
    [ "$modified" -gt 0 ]  && parts="${parts}${modified}~ "
    [ "$untracked" -gt 0 ] && parts="${parts}${untracked}? "
    if [ -n "$parts" ]; then
        printf " \033[0;90m[%s]\033[0m" "${parts% }"
    fi
fi

[ -n "$model" ] && printf " \033[0;36m%s\033[0m" "$model"

[ -n "$ctx_pct" ] && printf " \033[0;33mctx: %s%%\033[0m" "$ctx_pct"

if [ -n "$five_hr_pct" ]; then
    reset_str=""
    if [ -n "$resets_at" ] && [ "$resets_at" -gt 0 ] 2>/dev/null; then
        reset_time=$(date -d @"$resets_at" "+%-I:%M%p" 2>/dev/null || date -r "$resets_at" "+%-I:%M%p" 2>/dev/null)
        reset_time=$(printf '%s' "$reset_time" | tr '[:upper:]' '[:lower:]' | sed 's/:00\([ap]m\)/\1/')
        [ -n "$reset_time" ] && reset_str=$(printf " (%s)" "$reset_time")
    fi
    printf " \033[0;35m5h: %s%%%s\033[0m" "$five_hr_pct" "$reset_str"
fi

tok_in_fmt=$(abbrev "$tok_in")
tok_out_fmt=$(abbrev "$tok_out")
if [ -n "$tok_in_fmt" ] || [ -n "$tok_out_fmt" ]; then
    printf " \033[0;32m↓%s ↑%s" "${tok_in_fmt:-0}" "${tok_out_fmt:-0}"
    [ -n "$cache_pct" ] && printf " cache: %s%%" "$cache_pct"
    printf "\033[0m"
fi

printf "\n"
