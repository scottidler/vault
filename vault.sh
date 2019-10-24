#!/bin/bash

if [ -n "$DEBUG" ]; then
    PS4=':${LINENO}+'
    set -x
fi

function usage() {
    cat <<EOF
Usage: $0 [exec | login] <profile>
EOF
    exit $1
}

function vault() {
    op="$1"
    profile="$2"
    if [[ -z "$op" ]] || [[ -z "$profile" ]]; then
        usage 1
    fi
    case "$op" in
    exec)
        aws-vault --debug exec $profile --assume-role-ttl=1h --session-ttl=12h -- "${@:3}"
        ;;
    login)
        aws-vault --debug login $profile -s --assume-role-ttl=1h --federation-token-ttl=12h | tee >(xclip -sel clip)
        ;;
    *)
        usage 1
        ;;
    esac
}
