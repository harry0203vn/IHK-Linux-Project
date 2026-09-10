#!/bin/bash
# Real service outage, only after explicit console/snapshot approval.
source "$(dirname -- "$0")/lib.sh"
start_log test-ssh-outage
[[ ${1:-} = --apply && ${2:-} = --snapshot-confirmed ]] || die 'Requires --apply --snapshot-confirmed at console'
console_only
systemctl is-active --quiet ssh || die 'SSH must be active at baseline'
sshd -T | grep -qx 'port 22' || die 'This bounded test supports SSH port 22 only'
socket_active=0
systemctl is-active --quiet ssh.socket && socket_active=1
mkdir -p "$STATE/faults"
run=$(mktemp -d "$STATE/faults/ssh-$(date +%Y%m%dT%H%M%S)-XXXXXX")
exec > >(tee -a "$run/transcript.txt") 2>&1
recover() {
    systemctl start ssh
    if (( socket_active )); then systemctl start ssh.socket; fi
}
trap recover EXIT
# Independent recovery still starts ssh if the terminal is interrupted.
unit="ihk-ssh-recovery-$(date +%s)"
systemd-run --unit="$unit" --on-active=90s /usr/bin/systemctl start ssh
if (( socket_active )); then systemctl stop ssh.socket; fi
systemctl stop ssh
printf 'CONTROLLED SSH OUTAGE: service stopped, console remains available.\n'
systemctl is-active ssh || true
if timeout 3 bash -c 'echo > /dev/tcp/127.0.0.1/22'; then die 'Port still reachable; fault not established'; fi
printf 'Connection refused/failed observed locally. Restoring now.\n'
recover
systemctl is-active --quiet ssh
timeout 5 bash -c 'echo > /dev/tcp/127.0.0.1/22'
systemctl stop "$unit.timer"
printf 'F02 PASS: real service outage, TCP failure and recovery. Separate Windows SSH authentication test remains required.\n'
