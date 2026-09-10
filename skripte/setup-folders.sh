#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log setup-folders
safe_dir /company; safe_dir "$BACKUP"
install -d -m 755 /company
for g in it sales accounting management; do
    getent group "$g" >/dev/null || die "Missing group $g"
    safe_dir "/company/$g"
    install -d -o root -g "$g" -m 2770 "/company/$g"
    # IT administers department data via ACL, not blanket sudo.
    setfacl -m g:it:rwx,m::rwx,d:u::rwx,d:g::rwx,d:g:it:rwx,d:m::rwx,d:o::--- "/company/$g"
done
safe_dir /company/public
install -d -o root -g employees -m 2770 /company/public
setfacl -m d:u::rwx,d:g::rwx,d:m::rwx,d:o::--- /company/public
chown root:root "$BACKUP"; chmod 700 "$BACKUP"
ls -ld /company /company/* "$BACKUP"
getfacl -p /company/sales /company/accounting
