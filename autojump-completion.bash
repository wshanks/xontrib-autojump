_autojump() {
        local cur
        cur=${COMP_WORDS[*]:1}
        comps=$(autojump --complete $cur)
        while read i; do
            COMPREPLY=("${COMPREPLY[@]}" "${i}")
        done <<EOF
        $comps
EOF
}
complete -F _autojump j
