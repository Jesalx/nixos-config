#!/bin/sh

input=$(cat)

eval "$(echo "$input" | jq -r '
  @sh "cwd=\(.cwd // empty)",
  @sh "model=\(.model.display_name // empty)",
  @sh "ctx_pct=\(.context_window.used_percentage // empty | round)",
  @sh "five_hr_pct=\(.rate_limits.five_hour.used_percentage // empty | round)",
  @sh "resets_at=\(.rate_limits.five_hour.resets_at // empty)"
')"

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
        reset_time=$(date -r "$resets_at" "+%-I:%M%p" 2>/dev/null | tr '[:upper:]' '[:lower:]' | sed 's/:00\([ap]m\)/\1/')
        [ -n "$reset_time" ] && reset_str=$(printf " (%s)" "$reset_time")
    fi
    printf " \033[0;35m5h: %s%%%s\033[0m" "$five_hr_pct" "$reset_str"
fi

printf "\n"
