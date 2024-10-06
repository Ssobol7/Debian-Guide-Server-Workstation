

### Configuration Explanation:

- Incoming ICMP requests (like `ping`) are blocked.
- Only the following types of traffic are allowed:
  - Incoming connections on SSH (port 22).
  - HTTP and HTTPS (ports 80 and 443).
  - All outgoing connections are allowed.
  - Local connections via the `lo` interface are allowed.
  - All other incoming and forwarded packets are dropped.

***This configuration provides basic protection, making your server invisible to pings but still accessible via SSH, HTTP, and HTTPS.***


### Step 1: Installing `nftables`

1. Update the package list and install `nftables`:
   ```bash
   sudo apt update
   sudo apt install nftables
   ```

2. Enable automatic startup of `nftables` at system boot:
   ```bash
   sudo systemctl enable nftables
   ```

3. Start the `nftables` service:
   ```bash
   sudo systemctl start nftables
   ```

### Step 2: Configuring `nftables`

1. Open the `nftables` configuration file for editing:
   ```bash
   sudo nano /etc/nftables.conf
   ```

2. Add the following configuration to the file:

   ```nft
   #!/usr/sbin/nft -f

   flush ruleset

   table inet filter {
       chain input {
           type filter hook input priority 0; policy drop;

           # Allow loopback interface (local connections)
           iif "lo" accept

           # Allow already established connections
           ct state established,related accept

           # Block all incoming ICMP requests (ping)
           ip protocol icmp drop
           ip6 nexthdr ipv6-icmp drop

           # Allow SSH
           tcp dport 22 accept

           # Allow HTTP and HTTPS
           tcp dport { 80, 443 } accept
       }

       chain forward {
           type filter hook forward priority 0; policy drop;
       }

       chain output {
           type filter hook output priority 0; policy accept;
       }
   }
   ```

3. Save the file and exit the editor.

### Step 3: Applying `nftables` Rules

1. Apply the rules to make them effective:
   ```bash
   sudo nft -f /etc/nftables.conf
   ```

2. Check that the rules have been successfully applied:
   ```bash
   sudo nft list ruleset
   ```

### Step 4: Saving the Configuration

To ensure the rules are automatically applied after a reboot:

1. Save the current rules to the configuration file:
   ```bash
   sudo nft list ruleset > /etc/nftables.conf
   ```

2. Ensure the `nftables` service is enabled at boot:
   ```bash
   sudo systemctl enable nftables
   ```

### Step 5: Reboot and Verification

1. Reboot the system:
   ```bash
   sudo reboot
   ```

2. After the reboot, verify that the rules are still applied:
   ```bash
   sudo nft list ruleset
   ```


--- 

