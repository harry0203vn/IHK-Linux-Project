#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log install-admin-key
[[ $# = 1 && -f $1 ]] || die 'Pass one PUBLIC key file (.pub); never a private key'
[[ -f $STATE/admin-created ]] || die 'admin was not created by this project'
[[ $(wc -l < "$1") = 1 ]] || die 'Exactly one public key line required'
grep -Eq '^ssh-ed25519 [A-Za-z0-9+/=]+( .*)?$' "$1" || die 'Expected ed25519 public key'
ssh-keygen -lf "$1"
safe_dir /home/admin/.ssh
install -d -m 700 -o admin -g admin /home/admin/.ssh
keys=/home/admin/.ssh/authorized_keys
[[ ! -L $keys ]] || die 'Symlink refused'
touch "$keys"; chown admin:admin "$keys"; chmod 600 "$keys"
key=$(cat "$1")
grep -Fxq "$key" "$keys" || printf '%s\n' "$key" >> "$keys"
printf 'Key installed. A NEW Windows SSH key login must now be tested.\n'
