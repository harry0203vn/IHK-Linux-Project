#!/bin/bash
# Console-only; do not run until a Windows key login has succeeded.
source "$(dirname -- "$0")/lib.sh"
start_log configure-security
[[ ${1:-} = --apply && ${2:-} = --snapshot-confirmed && ${3:-} = --key-login-confirmed ]] || die 'Requires --apply --snapshot-confirmed --key-login-confirmed'
console_only
[[ -s /home/admin/.ssh/authorized_keys ]] || die 'Install admin public key first'
cfg=/etc/ssh/sshd_config.d/00-company-admin.conf
safe_dir /etc/ssh/sshd_config.d
[[ ! -L $cfg ]] || die 'Config symlink refused'
if [[ -e $cfg && ! -f $STATE/security-owned ]]; then die 'Existing config requires review'; fi
sshd -t
cp -a /etc/ssh "$STATE/rollback/ssh-before-$(date +%Y%m%dT%H%M%S)"
ufw status verbose
ufw show added > "$STATE/rollback/ufw-added-$(date +%Y%m%dT%H%M%S).txt"
cp -a /etc/ufw "$STATE/rollback/ufw-before-$(date +%Y%m%dT%H%M%S)"
old=$(mktemp "$STATE/sshd-XXXXXX")
had=0; [[ ! -e $cfg ]] || { cp -a "$cfg" "$old"; had=1; }
restore_config() {
    if (( had )); then cp -a "$old" "$cfg"; else rm -f -- "$cfg"; fi
}
printf 'PermitRootLogin no\nPubkeyAuthentication yes\n' > "$cfg"
chmod 600 "$cfg"
if ! sshd -t || [[ $(sshd -T | awk '$1=="permitrootlogin" {print $2}') != no ]]; then
    restore_config; die 'Effective SSH config conflict; previous file restored, review required'
fi
# Preserve password login and existing unrelated firewall rules.
ports=$(sshd -T | awk '$1=="port" {print $2}')
for port in $ports; do ufw allow "$port/tcp" comment 'IHK SSH'; done
systemctl reload ssh
ufw --force enable
touch "$STATE/security-owned"
ufw status verbose
sshd -T | grep -E '^(port|permitrootlogin|passwordauthentication|pubkeyauthentication) '
printf 'SECURITY CONFIGURED. Test a new Windows SSH session immediately.\n'
