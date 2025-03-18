# WSL 1Password SSH Agent Integration

This utility creates a bridge between Windows 1Password SSH agent and WSL (Windows Subsystem for Linux) environments. It allows you to use SSH keys stored in 1Password for authentication and Git commit signing from within WSL.

## How It Works

This project sets up a systemd service that creates a pipe between Windows and WSL using:
- `socat` to create a UNIX socket in WSL
- `npiperelay` to forward communication to the Windows named pipe used by 1Password

## Prerequisites

- WSL2 running a systemd-compatible Linux distribution
- 1Password application installed on Windows with SSH agent enabled
- [npiperelay.exe](https://github.com/jstarks/npiperelay) available on your Windows system
- `socat` installed in your WSL environment (`sudo apt install socat`)

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/wsl-1password-service.git
   cd wsl-1password-service
   ```

2. Run the installation script with sudo:
   ```bash
   sudo ./install.sh
   ```

3. Follow the prompts to enter:
   - Your WSL username
   - The directory path where npiperelay.exe is located on your Windows system
     (e.g., `/mnt/c/Users/YourUser/bin`)

## Verification

After installation, verify that the service is running:

```bash
systemctl status 1password
```

You should see the service active and running without errors.

## Usage

Once installed, you can use SSH and Git signing with your 1Password keys. The service will automatically start when your WSL instance boots.

Test with:
```bash
ssh-add -l
```

This should list your SSH keys from 1Password.

## Troubleshooting

If you encounter issues:

1. Check service status:
   ```bash
   systemctl status 1password
   ```

2. Check the service logs:
   ```bash
   journalctl -u 1password
   ```

3. Verify socat is running:
   ```bash
   ps aux | grep socat
   ```

4. Make sure your SSH_AUTH_SOCK environment variable is set:
   ```bash
   echo $SSH_AUTH_SOCK
   ```

## Uninstall

To remove the service:

```bash
sudo systemctl stop 1password
sudo systemctl disable 1password
sudo rm /etc/systemd/system/1password.service
sudo rm -rf /etc/1password-ssh-agent
```

## Credits

The `agent-bridge.sh` script used in this project is based on the work by WillianTomaz:
- [WSL SSH-Agent Bridge Gist](https://gist.github.com/WillianTomaz/a972f544cc201d3fbc8cd1f6aeccef51)
