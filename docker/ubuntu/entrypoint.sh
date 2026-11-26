#!/bin/sh
set -eu

mkdir -p /run/sshd /root/.ssh
chmod 700 /root/.ssh

if [ "${GENERATE_CONTROLLER_KEY:-0}" = "1" ]; then
    if [ ! -f /root/.ssh/id_ed25519 ]; then
        ssh-keygen -q -t ed25519 -N "" -f /root/.ssh/id_ed25519
    fi

    mkdir -p /shared-pub
    cp /root/.ssh/id_ed25519.pub /shared-pub/id_ed25519.pub
else
    i=0
    until [ -s /shared-pub/id_ed25519.pub ]; do
        i=$((i + 1))
        if [ "$i" -ge 120 ]; then
            echo "SSH public key not available"
            exit 1
        fi
        sleep 1
    done

    cp /shared-pub/id_ed25519.pub /root/.ssh/authorized_keys
fi

chmod 600 /root/.ssh/authorized_keys 2>/dev/null || true

ssh-keygen -A

cat > /etc/ssh/sshd_config <<'CONFIG'
Port 22
PermitRootLogin prohibit-password
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
AuthorizedKeysFile .ssh/authorized_keys
Subsystem sftp internal-sftp
CONFIG

/usr/sbin/sshd

if [ "${START_NGINX:-0}" = "1" ]; then
    nginx
fi

exec sleep infinity
