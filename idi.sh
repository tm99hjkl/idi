#!/usr/bin/env bash

set -eo pipefail
CMD="idi"
PREFIX="$HOME/.$CMD"
PATH_OR_CONTENTS='if [[ "$(file -b --mime {})" == *charset=binary* ]]; then echo -n '$PREFIX'/{}; else cat {}; fi'
CLIP="xsel -bi"
FZF_BIND_COMMANDS=(
    "enter:execute-silent(bash -c '$PATH_OR_CONTENTS' | $CLIP)"
)
FZF_OPTS=(
    --height=40
    --preview='bat -p {} --color always --theme=Nord'
    --bind="$(IFS=, eval 'echo "${FZF_BIND_COMMANDS[*]}"')" # one-line IFS trick
)
EDITOR="hx" # can be vi, vim, emacs, etc...


## utils
die() {
    echo "$@" >&2
    exit 1
}

yesno() {
    [[ -t 0 ]] || return 0
    local response
    read -r -p "$1 [y/N] " response
    [[ $response == [yY] ]] || exit 1
}


## subcommands
cmd_help() {
    cat <<EOF
Usage:
    $CMD [search]
        Search for snippets in the $PREFIX using fzf. 
        Pressing Enter in the preview window copies the contents (full path if not text) to the clipboard.
    $CMD add <filename>...
        Add a snippet <filename>. The extension of <filename> is used as the directory name.
    $CMD new [<filename>...]
        Create a new snippet (or new snippets).
    $CMD help
        Show this text.
EOF
}

cmd() {
    [[ -d "$PREFIX" ]] || (yesno "Initialize $PREFIX?" && mkdir -p "$PREFIX" && exit 1)

    pushd $PREFIX >/dev/null
    fzf "${FZF_OPTS[@]}"
    popd >/dev/null
}

cmd_add() {
    [[ "$#" -ne 0 ]] || die "Usage: $CMD add <filename>"

    for file in "$@"; do
        [[ -e "$file" ]] || die "Error: $file does not exists."

        local idiom_file=$(basename $file)
        local ext="${idiom_file##*\.}"
        local target_dir="$PREFIX/$ext"

        [[ -d "$target_dir" ]] || (yesno "mkdir $target_dir?" && mkdir -p "$target_dir")
        [[ -e "$target_dir/$idiom_file" ]] && yesno "update $idiom_file?"

        mv "$file" "$PREFIX/$ext/$idiom_file"
    done
}

cmd_new() {
    local tmp_dir=`mktemp -d`

    pushd $tmp_dir >/dev/null
    $EDITOR "$@"
    popd >/dev/null

    for idiom_file in `ls $tmp_dir`; do
        idiom_files+=($tmp_dir/$idiom_file)
    done

    [[ -z "${idiom_files[@]}" ]] || cmd_add "${idiom_files[@]}"

    rmdir $tmp_dir
}


## main
case "$1" in
    help|--help) shift; cmd_help "$@" ;;
    add)         shift; cmd_add "$@" ;;
    new)         shift; cmd_new "$@" ;;
    *)           cmd "$@" ;;
esac

exit 0
