## Packet filtering system `nftables`

&nbsp;

> `nftables` is a packet filtering subsystem in the Linux kernel that provides a unified and optimized replacement for utilities such as `iptables`, `ip6tables`, `arptables`, and `ebtables`.
>
> It was designed to simplify the management of network filtering rules, improve performance, and offer more flexible capabilities compared to its predecessors.

&nbsp;

***The configuration below is an example and provides only basic protection, making your server invisible to pings, but accessible via SSH, HTTP and HTTPS, you can change it according to your security requirements for your systemssible via SSH, HTTP, and HTTPS.***

&nbsp;

### Configuration Explanation:

- Incoming ICMP requests (like `ping`) are blocked.
- Only the following types of traffic are allowed:
  - Incoming connections on SSH (port 22).
  - HTTP and HTTPS (ports 80 and 443).
  - All outgoing connections are allowed.
  - Local connections via the `lo` interface are allowed.
  - All other incoming and forwarded packets are dropped.

&nbsp;

### Step 1: Installing `nftables`

1. Update the package list and install `nftables`:
   ```bash
   $ sudo apt update
   $ sudo apt install nftables
   ```

2. Enable automatic startup of `nftables` at system boot:
   ```bash
   $ sudo systemctl enable nftables
   ```

3. Start the `nftables` service:
   ```bash
   $ sudo systemctl start nftables
   ```
   
&nbsp;

### Step 2: Configuring `nftables`

1. Open the `nftables` configuration file for editing:
   ```bash
   $ sudo nano /etc/nftables.conf
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

&nbsp;

### Step 3: Applying `nftables` Rules

1. Apply the rules to make them effective:
   ```bash
   $ sudo nft -f /etc/nftables.conf
   ```

2. Check that the rules have been successfully applied:
   ```bash
   $ sudo nft list ruleset
   ```

   ![nftables](https://github.com/user-attachments/assets/4408991c-8e25-4faa-9dac-045872e26dd2)


    - **table inet filter**: A table created for both IPv4 and IPv6 protocols.
    - **chain input**: The chain for processing incoming traffic. The default policy is `drop` (block everything that is not explicitly allowed).
    - **iif "lo" accept**: All connections on the loopback interface (`lo`) are allowed.
    - **ct state established,related accept**: Already established and related connections are allowed.
    - **ip protocol icmp drop**: All incoming ICMP requests (ping) are blocked.
    - **ip6 nexthdr ipv6-icmp drop**: Incoming ICMP requests for IPv6 are blocked.
    - **tcp dport 22 accept**: Incoming SSH connections (port 22) are allowed.
    - **tcp dport { 80, 443 } accept**: Incoming HTTP (port 80) and HTTPS (port 443) connections are allowed.
    - **chain forward**: The chain for forwarding traffic. The default policy is `drop`.
    - **chain output**: The chain for outgoing traffic. The default policy is `accept` (everything is allowed).


&nbsp;


### Step 4: Saving the Configuration

To ensure the rules are automatically applied after a reboot:

1. Save the current rules to the configuration file:
   ```bash
   $ sudo nft list ruleset > /etc/nftables.conf
   ```

   

2. Ensure the `nftables` service is enabled at boot:
   ```bash
   $ sudo systemctl enable nftables
   ```

&nbsp;

### Step 5: Reboot your system and verification

1. Reboot the system:
   ```bash
   $ sudo reboot
   ```

2. **After the reboot**, verify that the rules are still applied:
   ```bash
   sudo nft list ruleset
   ```
   
&nbsp;

--- 

&nbsp;


