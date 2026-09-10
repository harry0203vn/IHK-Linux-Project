#!/bin/bash
# Shared functions: fixed production paths, explicit errors, protected logs.
set -Eeuo pipefail
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
export LC_ALL=C
umask 027
BASE=/opt/company
DATA=$BASE/data
LOG=/var/log/company-admin
BACKUP=/backup/company
STATE=/var/lib/company-admin
SELF=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
root_only() { [[ $EUID -eq 0 ]] || die 'Run with sudo (root required).'; }
console_only() {
    [[ -z ${SSH_CONNECTION:-} ]] || die 'Use the VMware console, not SSH'
    # sudo may remove SSH_CONNECTION; inspect ancestors as well.
    local pid=$$ comm
    while [[ $pid =~ ^[0-9]+$ ]] && (( pid > 1 )); do
        comm=$(ps -o comm= -p "$pid") || die 'Cannot verify session ancestry'
        [[ $comm != sshd* ]] || die 'SSH ancestor detected; use VMware console'
        pid=$(ps -o ppid= -p "$pid" | tr -d ' ')
    done
}
safe_dir() {
    local p=$1 current=/ part
    local -a parts
    [[ $p = /* && $p != / && $p != *'/../'* ]] || die "Unsafe path: $p"
    IFS=/ read -ra parts <<< "$p"
    for part in "${parts[@]}"; do
        [[ -n $part ]] || continue
        current=${current%/}/$part
        [[ ! -L $current ]] || die "Symlink refused: $current"
        [[ ! -e $current || -d $current ]] || die "Not a directory: $current"
    done
}
managed() {
    safe_dir "$STATE"
    [[ -f $STATE/managed && ! -L $STATE/managed ]] || die 'Project not installed; run install-project.sh first.'
    [[ $(stat -c %u "$STATE/managed") = 0 ]] || die 'Invalid management marker.'
}
start_log() {
    root_only; managed; safe_dir "$LOG"
    [[ -d $LOG ]] || die 'Missing log directory.'
    local name=${1%.sh}
    [[ $name =~ ^[a-z0-9-]+$ ]] || die 'Invalid log name'
    [[ ! -L $LOG/$name.log ]] || die 'Log symlink refused'
    exec > >(tee -a "$LOG/$name.log") 2>&1
    trap 'rc=$?; printf "ERROR rc=%s line=%s command=%s\n" "$rc" "$LINENO" "$BASH_COMMAND" >&2; exit "$rc"' ERR
    printf '\n[%s] START %s\n' "$(date -Is)" "$name"
}
valid_name() { [[ $1 =~ ^[a-z][a-z0-9._-]{0,30}$ ]]; }
report_path() {
    safe_dir "$LOG/reports"
    mkdir -p "$LOG/reports"
    mktemp "$LOG/reports/$1-$(date +%Y%m%dT%H%M%S)-XXXXXX.txt"
}
backup_files() {
    find "$BACKUP" -maxdepth 1 -type f -name 'company-????????T??????-*.tar.gz' -printf '%T@ %p\n' | sort -nr
}
