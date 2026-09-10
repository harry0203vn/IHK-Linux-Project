#!/bin/bash
# Functional tests on the real VM only. Every result is captured when executed.
source "$(dirname -- "$0")/lib.sh"
start_log run-tests
[[ ${1:-} = --apply ]] || die 'Use --apply: creates and restores an isolated test file under /company/sales'
safe_dir "$STATE/tests"; mkdir -p "$STATE/tests"
run=$(mktemp -d "$STATE/tests/run-$(date +%Y%m%dT%H%M%S)-XXXXXX")
results=$run/results.tsv
printf 'id\tstatus\tpurpose\n' > "$results"
failed=0
testcase() {
    local id=$1 purpose=$2; shift 2
    if "$@" > "$run/$id.txt" 2>&1; then status=PASS; else status=FAIL; failed=$((failed+1)); fi
    printf '%s\t%s\t%s\n' "$id" "$status" "$purpose" | tee -a "$results"
}
pending() { printf '%s\tPENDING\t%s\n' "$1" "$2" | tee -a "$results"; }
testcase T02 hostname bash -c '[[ $(hostname) = server01 ]]'
testcase T03 groups bash -c '[[ $(id -gn sales01) = sales ]] && id -Gn sales01 | tr " " "\n" | grep -qx employees'
testcase T04 sales-access runuser -u sales01 -- test -w /company/sales
testcase T05 accounting-denied bash -c '! runuser -u sales01 -- test -r /company/accounting && ! runuser -u sales01 -- test -w /company/accounting'
# Rerun and compare account identity/group records, not changing log timestamps.
getent passwd it.admin support01 sales01 sales02 accounting01 management01 intern01 > "$run/users-before"
testcase T06a setup-users-first "$SELF/setup-users.sh"
testcase T06b setup-users-second "$SELF/setup-users.sh"
getent passwd it.admin support01 sales01 sales02 accounting01 management01 intern01 > "$run/users-after"
testcase T06 idempotent-identities cmp "$run/users-before" "$run/users-after"
testcase T07 setup-folders "$SELF/setup-folders.sh"
testcase T17 second-user-isolation bash -c 'runuser -u accounting01 -- test -w /company/accounting && ! runuser -u accounting01 -- test -r /company/sales'
testcase T18 it-acl runuser -u it.admin -- bash -c 'f=$(mktemp /company/accounting/.it-acl-probe-XXXXXX) && rm -f "$f"'
testcase T19 public-group runuser -u intern01 -- test -w /company/public
testcase T20 backup-private bash -c '! runuser -u sales01 -- test -r /backup/company'
probe=$(mktemp /company/sales/ihk-restore-XXXXXX.txt)
printf 'IHK real restore test %s\n' "$(date -Is)" > "$probe"
chown sales01:sales "$probe"; chmod 640 "$probe"
sha256sum "$probe" > "$run/restore-before.sha256"
testcase T08 backup "$SELF/backup-company.sh"
archive=$(backup_files | sed -n '1s/^[^ ]* //p')
if [[ -n $archive ]] && tar -tzf "$archive" | grep -Fxq "${probe#/}"; then
    printf 'DELETE test file only: %s\n' "$probe" | tee "$run/restore-deletion.txt"
    rm -- "$probe"
    testcase T09a restore "$SELF/restore-company.sh" "$archive" "${probe#/company/}"
    testcase T09 restore-content sha256sum --check "$run/restore-before.sha256"
else
    printf 'T09\tFAIL\tbackup missing test member; no deletion attempted\n' | tee -a "$results"; failed=$((failed+1))
fi
testcase T11 disk "$SELF/check-disk.sh"
testcase T12 services "$SELF/check-services.sh"
testcase T13 ssh-audit "$SELF/ssh-audit.sh"
testcase T14 log-report "$SELF/log-report.sh"
testcase T15 daily-report "$SELF/daily-admin-report.sh"
testcase T16 firewall bash -c 'ufw status | grep -q "^Status: active" && ufw status | grep -Eq "22/tcp.*ALLOW"'
testcase T21 cleanup-preview "$SELF/cleanup-old-files.sh" --dry-run
testcase T22 admin-sudo bash -c 'id -Gn admin | tr " " "\n" | grep -qx sudo'
testcase T23 csv-valid python3 "$SELF/validate-csv.py" "$DATA/groups.csv" "$DATA/users.csv"
pending T01 'Windows SSH login and key authentication: external evidence required'
pending T10 'Real cron timestamps and corresponding output: operator must run probe and review journal'
pending T24 'Retention boundary: controlled fixtures and review required'
printf 'Automated failures=%s. PENDING is not PASS. Results: %s\n' "$failed" "$run"
printf '%s\n' "$run" > "$STATE/latest-test-run"
(( failed == 0 ))
