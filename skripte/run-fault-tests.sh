#!/bin/bash
# Controlled, REAL faults. Console only; preserves ACLs/groups with EXIT cleanup.
# SSH outage and live cron failure are separate procedures, not silently counted here.
source "$(dirname -- "$0")/lib.sh"
start_log run-fault-tests
[[ ${1:-} = --apply && ${2:-} = --snapshot-confirmed ]] || die 'Requires --apply --snapshot-confirmed at VMware console'
console_only
[[ $(id -gn sales01) = sales ]] || die 'Baseline sales01 primary group must be sales'
runuser -u sales01 -- test -w /company/sales || die 'Baseline access failed'
safe_dir "$STATE/faults"; mkdir -p "$STATE/faults"
run=$(mktemp -d "$STATE/faults/run-$(date +%Y%m%dT%H%M%S)-XXXXXX")
getfacl -p /company/sales "$BACKUP" > "$run/baseline.acl"
backup_parent_mode=$(stat -c '%a' /backup)
restore() {
    local rc=$?
    usermod -g sales sales01 || printf 'RESTORE ERROR: primary group\n' >&2
    chmod "$backup_parent_mode" /backup || printf 'RESTORE ERROR: /backup mode\n' >&2
    setfacl --restore="$run/baseline.acl" || printf 'RESTORE ERROR: ACL\n' >&2
    return "$rc"
}
trap restore EXIT
exec > >(tee -a "$run/transcript.txt") 2>&1
printf 'id\tstatus\tdescription\n' > "$run/results.tsv"
record() { printf '%s\t%s\t%s\n' "$1" "$2" "$3" | tee -a "$run/results.tsv"; }
printf 'F01 BEFORE\n'; getfacl /company/sales
setfacl -m g::r-x,m::r-x /company/sales
if runuser -u sales01 -- test -w /company/sales; then die 'F01 injection not observed'; fi
printf 'F01 observed: sales01 write access denied\n'
setfacl --restore="$run/baseline.acl"
runuser -u sales01 -- test -w /company/sales
record F01 PASS 'Controlled folder permission fault observed and corrected'
printf 'F04 missing backup target\n'
if "$SELF/backup-company.sh" --fault-test-missing-target; then die 'Expected backup failure absent'; fi
"$SELF/backup-company.sh"
record F04 PASS 'Controlled missing-target backup error and normal backup retest'
usermod -g employees sales01; id sales01
if runuser -u sales01 -- test -w /company/sales; then die 'F05 injection not observed'; fi
usermod -g sales sales01; id sales01
runuser -u sales01 -- test -w /company/sales
record F05 PASS 'Missing primary department group denied access; restored'
if runuser -u sales01 -- "$SELF/setup-users.sh" > "$run/no-sudo.txt" 2>&1; then die 'Root guard failed'; fi
cat "$run/no-sudo.txt"
grep -q 'root required' "$run/no-sudo.txt"
"$SELF/setup-users.sh"
record F06 PASS 'Root guard rejected non-root; normal root run succeeded'
cp "$DATA/users.csv" "$run/users-invalid.csv"
printf 'broken,line\n' >> "$run/users-invalid.csv"
if python3 "$SELF/validate-csv.py" "$DATA/groups.csv" "$run/users-invalid.csv"; then die 'Invalid CSV accepted'; fi
python3 "$SELF/validate-csv.py" "$DATA/groups.csv" "$DATA/users.csv"
record F07 PASS 'Malformed CSV rejected before mutation; original CSV validates'
# Only project backup directory, not /backup or unrelated backups.
# /backup itself must also be opened: a 750 parent blocks traversal regardless
# of the child's mode, so injecting only on $BACKUP never reproduces this fault.
chmod 755 /backup "$BACKUP"; ls -ld /backup "$BACKUP"
runuser -u sales01 -- test -r "$BACKUP"
printf 'F08 observed: employee can list backup names (archives remain 600)\n'
chmod "$backup_parent_mode" /backup; setfacl --restore="$run/baseline.acl"; ls -ld /backup "$BACKUP"
if runuser -u sales01 -- test -r "$BACKUP"; then die 'F08 correction failed'; fi
record F08 PASS 'Overly readable backup directory detected and permissions restored'
record F02 PENDING 'SSH outage: separate controlled console procedure required'
record F03 PENDING 'Cron wrong path: real scheduled execution required'
printf 'FAULT RESULTS %s; two required cases remain pending.\n' "$run"
