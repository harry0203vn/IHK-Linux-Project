#!/bin/bash
# Additional AF02/03/09; controlled access changes and one new managed user.
source "$(dirname -- "$0")/lib.sh"
start_log run-business-cases
[[ ${1:-} = --apply && ${2:-} = --snapshot-confirmed ]] || die 'Requires --apply --snapshot-confirmed at console'
console_only
safe_dir "$STATE/faults"; mkdir -p "$STATE/faults"
run=$(mktemp -d "$STATE/faults/business-$(date +%Y%m%dT%H%M%S)-XXXXXX")
exec > >(tee -a "$run/transcript.txt") 2>&1
getfacl -p /company/accounting > "$run/accounting.acl"
trap 'setfacl --restore="$run/accounting.acl"' EXIT
if runuser -u sales01 -- test -r /company/accounting; then die 'AF02 baseline already too open; review before injection'; fi
setfacl -m u:sales01:r-x /company/accounting
# bash 'test -r' does not reliably reflect a named-user ACL grant in this
# environment (same class of false-negative as T18/F-AP11-01); use a real
# read attempt instead.
runuser -u sales01 -- bash -c 'ls /company/accounting >/dev/null'
getfacl -p /company/accounting
printf 'AF02 observed: unauthorized department access\n'
setfacl --restore="$run/accounting.acl"
if runuser -u sales01 -- test -r /company/accounting; then die 'AF02 correction failed'; fi
printf 'AF02 PASS: original ACL restored and access denied\n'
if ! grep -q '^sales03,' "$DATA/users.csv"; then
    if getent passwd sales03 >/dev/null; then die 'sales03 exists outside CSV; review needed'; fi
    [[ ! -e /home/sales03 && ! -L /home/sales03 ]] || die 'sales03 home collision'
    cp -a "$DATA/users.csv" "$run/users-before.csv"
    printf 'sales03,sales,employees,Vertrieb Mitarbeiter 03\n' >> "$DATA/users.csv"
fi
python3 "$SELF/validate-csv.py" "$DATA/groups.csv" "$DATA/users.csv"
"$SELF/setup-users.sh"
id sales03
[[ $(id -gn sales03) = sales ]]
id -Gn sales03 | tr ' ' '\n' | grep -qx employees
printf 'AF03 PASS: sales03 remains a managed employee; export updated CSV back into local project\n'
if getent passwd ihk.invalid >/dev/null; then die 'AF09 test user unexpectedly exists'; fi
[[ -f /etc/ssh/ssh_host_ed25519_key.pub ]] || die 'No local ed25519 host key'
sshd -T | grep -qx 'port 22' || die 'AF09 supports local port 22 only'
printf '127.0.0.1 %s\n' "$(awk '{print $1" "$2}' /etc/ssh/ssh_host_ed25519_key.pub)" > "$run/known_hosts"
since=$(date -Is)
if ssh -o BatchMode=yes -o ConnectTimeout=5 -o IdentitiesOnly=yes -o IdentityFile=/dev/null -o PreferredAuthentications=publickey -o StrictHostKeyChecking=yes -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile="$run/known_hosts" ihk.invalid@127.0.0.1 true; then
    die 'Unexpected invalid-user login succeeded'
fi
sleep 2
# Modern OpenSSH (Ubuntu) splits the daemon: the listener stays "sshd" but
# each connection is handled by a re-exec'd "sshd-session" child, which is
# the process that actually logs "Invalid user ...". Match both COMM values
# so this probe finds the real journal entry regardless of OpenSSH version.
journalctl --since "$since" _COMM=sshd _COMM=sshd-session --no-pager > "$run/invalid-login.txt"
cat "$run/invalid-login.txt"
grep -qi 'ihk.invalid' "$run/invalid-login.txt" || die 'No corresponding SSH journal event; review journal source'
printf 'AF09 PASS: controlled LOCAL failed login and matching real journal event. Not an external attack or Windows SSH proof.\n'
