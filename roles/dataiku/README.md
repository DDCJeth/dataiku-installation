Dataiku Ansible role

This role installs Dataiku DSS from the public downloads URL, runs the dependency installer,
runs the node installer and install-boot script, and deploys a simple systemd service.

Variables (defaults in `defaults/main.yml`):
- `dataiku_version`: version string (default `13.5.5`)
- `download_url`: URL used to download the tar.gz
- `install_base`: base directory where the archive is extracted (default `/opt`)
- `dss_user`: Linux user to run DSS (default `jeth`)

Usage: invoked from `playbook.yml` with per-play vars for `node_type`, `dss_port`, `data_dir`, and `boot_name`.
