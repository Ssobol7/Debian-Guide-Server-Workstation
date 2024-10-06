
# Fail2Ban 

## Installation and configuration 

---

### Step 1: Installing `Fail2Ban`

1. Update the package list:
   ```bash
   sudo apt update
   ```

2. Install `Fail2Ban`:
   ```bash
   sudo apt install fail2ban
   ```

### Step 2: Configuring `Fail2Ban`

1. Create a local configuration file:
   To save custom settings and avoid them being overwritten during updates, create the file `/etc/fail2ban/jail.local`:

   ```bash
   sudo nano /etc/fail2ban/jail.local
   ```

2. Add the following basic configuration for SSH protection:
   
   ```ini
   [sshd]
   enabled = true
   port = 22
   logpath = /var/log/auth.log
   maxretry = 3
   bantime = 3600
   findtime = 600
   ```

   - **enabled = true**: Activates protection for SSH.
   - **port = 22**: Specifies the port for monitoring (SSH).
   - **logpath**: Path to the log file where SSH login attempts are recorded.
   - **maxretry = 3**: Maximum number of failed login attempts before banning an IP.
   - **bantime = 3600**: Duration of the IP ban (in seconds).
   - **findtime = 600**: Time period within which the 3 failed attempts are counted (in seconds).

3. Configure interaction with `nftables`:
   
   To allow `Fail2Ban` to block IP addresses using `nftables`, add the following settings in `/etc/fail2ban/jail.local` to use `nftables`:

   ```ini
   [DEFAULT]
   banaction = nftables-multiport
   banaction_allports = nftables-allports
   ```

   This tells `Fail2Ban` to use `nftables` for banning IP addresses.

### Step 3: Verifying Configuration

1. Check the configuration for errors:
   ```bash
   sudo fail2ban-client -t
   ```

2. Restart `Fail2Ban` to apply the settings:
   ```bash
   sudo systemctl restart fail2ban
   ```

### Step 4: Monitoring and Management

1. **Check the status of `Fail2Ban` and its rules**:
   To check how `Fail2Ban` is working with the SSH jail:
   ```bash
   sudo fail2ban-client status sshd
   ```

2. **Manually ban an IP address**:
   To manually ban an IP address using `Fail2Ban`:
   ```bash
   sudo fail2ban-client set sshd banip <IP-address>
   ```

3. **Unban an IP address**:
   To unban an IP address:
   ```bash
   sudo fail2ban-client set sshd unbanip <IP-address>
   ```

### Step 5: Additional Configuration for Protecting Other Services

If you want to protect other services (e.g., HTTP or HTTPS), add additional `jail` configurations in the `/etc/fail2ban/jail.local` file. For example, to protect a web server:

```ini
[nginx-http-auth]
enabled = true
port = http,https
logpath = /var/log/nginx/error.log
maxretry = 5
```

### Step 6: Checking Logs

To diagnose issues with `Fail2Ban`, you can view the logs:
```bash
sudo journalctl -u fail2ban
```

### Important Notes:

- Ensure that the `/var/log/auth.log` file exists and is being used to track SSH login attempts.
- Ensure that port 22 for SSH is allowed in your `nftables` configuration, as was set up in previous steps.

Now, your server will be protected with `Fail2Ban`, which will automatically block IP addresses after several failed login attempts, using `nftables` to block traffic.
