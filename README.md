# Nebari FRP Server for Deployment Previews

[![Ansible Tasks](https://github.com/nebari-dev/frp-server/actions/workflows/ansible_run.yml/badge.svg)](https://github.com/nebari-dev/frp-server/actions/workflows/ansible_run.yml)

This is the infrastructure setup for enabling pull request deployment previews via FRP tunneling.
This repository contains the necessary configuration to deploy and manage an FRP server on Hetzner,
facilitating pull request preview environments for Nebari.

## 🔑 Server Access

The FRP server can be accessed via SSH. User access is managed through an Ansible task that
runs on pushes to the main branch.

### 👥 For Nebari Core Team Members

To gain access to the server:

1. Submit a PR to `ansible/vars/users.yaml` adding your GitHub username
2. After the PR is merged, the Ansible playbook will automatically run
3. Connect to the server using:

```bash
ssh ubuntu@frp.nebari.dev
```

> **Note**: Server access is restricted to Nebari core team members only.

### FRP Configuration

The FRP server is configured in `frp_config/frps.toml`. Key settings include:

- **bind_port**: Port for FRP client connections (default: 7000)
- **token**: Authentication token for clients

## Integration with GitHub Repositories

To use this FRP server for preview deployments in your repositories, add the [FRP tunnel action](https://github.com/cirunlabs/frp-tunnel-action) to your workflow. See example usage [here](https://github.com/aktech/github-actions-deploy-previews/blob/main/.github/workflows/deploy.yml).

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
