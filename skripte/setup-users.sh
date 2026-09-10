#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log setup-users
exec 9>"$STATE/users.lock"; flock -n 9 || die 'User setup already running'
python3 "$SELF/validate-csv.py" "$DATA/groups.csv" "$DATA/users.csv"
groups=$(python3 "$SELF/validate-csv.py" "$DATA/groups.csv" "$DATA/users.csv" groups)
users=$(python3 "$SELF/validate-csv.py" "$DATA/groups.csv" "$DATA/users.csv" users)
touch "$STATE/groups-owned" "$STATE/users-owned"
# Precheck ALL collisions before mutation.
while read -r g; do
    if getent group "$g" >/dev/null && ! grep -Fxq "$g" "$STATE/groups-owned"; then die "Unmanaged group $g"; fi
done <<< "$groups"
while IFS=$'\t' read -r u primary extra full; do
    if getent passwd "$u" >/dev/null && ! grep -Fxq "$u" "$STATE/users-owned"; then die "Unmanaged user $u"; fi
    if ! getent passwd "$u" >/dev/null; then [[ ! -e /home/$u && ! -L /home/$u ]] || die "Existing home $u"; fi
done <<< "$users"
while read -r g; do
    if ! getent group "$g" >/dev/null; then
        printf '%s\n' "$g" >> "$STATE/groups-owned"
        groupadd "$g"; printf 'CREATED group %s\n' "$g"
    else printf 'EXISTS group %s\n' "$g"; fi
done <<< "$groups"
while IFS=$'\t' read -r u primary extra full; do
    if ! getent passwd "$u" >/dev/null; then
        printf '%s\n' "$u" >> "$STATE/users-owned"
        useradd -m -g "$primary" -s /bin/bash -c "$full" "$u"
        printf 'CREATED user %s (password locked)\n' "$u"
    fi
    usermod -g "$primary" -c "$full" "$u"
    [[ $extra = - ]] || usermod -aG "$extra" "$u"
    id "$u"
done <<< "$users"
printf 'DONE. Reruns reconcile primary groups and add required supplementary groups; unrelated memberships are preserved.\n'
