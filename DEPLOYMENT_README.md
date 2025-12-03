# Dataiku DSS Ansible Deployment

This document describes how to deploy Dataiku DSS nodes using the Ansible playbook and role provided in this directory.

**Prerequisites**
- Control machine: Linux with `ansible` installed (Ansible 2.9+ recommended).
- Targets: reachable via SSH with Python 3 installed.
- SSH key: `multipass-ssh-key` (present in this directory) or another key configured in `group_vars` / `host_vars`.
- Internet access from targets (or an alternate `download_url` pointing to an accessible tarball).

**Repository layout**
- `inventory.ini` — Ansible inventory (groups: `design`, `automation`, `deployer`, `api`).
- `playbook.yml` — Main playbook (three plays: design, automation, deployer).
- `group_vars/` — Per-group variables (ports, data dirs, boot names) and `all.yml` for global defaults.
- `host_vars/` — Per-host overrides (labels, flags, etc.).
- `roles/dataiku/` — Role performing download, install, `install-boot`, and systemd service deployment.

**Important variables**
- `dataiku_version` — version to download (default in `group_vars/all.yml`).
- `download_url` — URL to the Dataiku tarball (default built from `dataiku_version`).
- `install_base` — where the archive is extracted (default `/opt`).
- `dss_user` — OS user that will run DSS (default `jeth`).
- Per-group: `dss_port`, `data_dir`, `boot_name`, `service_name` found in `group_vars/<group>.yml`.
- Connection settings are set in `group_vars/all.yml` via `ansible_user` and `ansible_ssh_private_key_file`.

**Run the playbook**
1. From this directory, validate the inventory and connectivity:

```bash
ansible -i inventory.ini all -m ping -u jeth --private-key ./multipass-ssh-key
```

2. Run the playbook (adjust `-u` / `--private-key` if needed):

```bash
ansible-playbook -i inventory.ini playbook.yml -u jeth --private-key ./multipass-ssh-key
```

3. To perform a dry-run (Ansible check mode):

```bash
ansible-playbook -i inventory.ini playbook.yml -u jeth --private-key ./multipass-ssh-key --check --diff
```

4. To override variables at runtime, use `-e`:

```bash
ansible-playbook -i inventory.ini playbook.yml -u jeth --private-key ./multipass-ssh-key \
  -e dataiku_version=13.5.5 -e dss_user=jeth
```

**Offline / air-gapped installs**
- If targets cannot reach `downloads.dataiku.com`, pre-copy the tarball to each host (e.g. `/tmp`) and set `download_url` to `"file:///tmp/dataiku-dss-<version>.tar.gz"` in `host_vars` or `group_vars`.

**Verification**
- After the playbook completes, check systemd for the service name defined in `group_vars` (e.g., `dataiku.dev` or `dataiku.prod`):

```bash
ssh -i multipass-ssh-key jeth@<host-ip> 'sudo systemctl status dataiku.dev'
ssh -i multipass-ssh-key jeth@<host-ip> 'sudo journalctl -u dataiku.dev --no-pager | tail -n 200'
```

- Confirm DSS is listening on the configured port (e.g., `10000` for design):

```bash
ssh -i multipass-ssh-key jeth@<host-ip> 'ss -tlnp | grep 10000'
```

**Troubleshooting**
- Check installer logs under `$DKUINSTALLDIR/run/` on the target host.
- Ensure the Java runtime is present (`java -version`) — the role installs OpenJDK 11 by default for Debian/RedHat families.
- If a task fails downloading the archive, verify `download_url` or pre-copy the tarball.

**Next steps / recommendations**
- Add a preflight play (disk, RAM, port checks) before the install. The role ships with `preflight_*` variables you can use to implement such checks.
- Consider creating `group_vars` entries for `ansible_become` / `ansible_become_user` if you need different privilege escalation behavior.
- Add vault-encrypted variables for sensitive values (API keys, credentials).

If you'd like, I can add a preflight check play to `playbook.yml` that uses `preflight_min_disk_gb`, `preflight_min_ram_gb`, and `required_ports` to verify readiness before installing.
