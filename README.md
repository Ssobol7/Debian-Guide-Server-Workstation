![deb](https://github.com/Ssobol7/Debian-12-Xfce-My-Config/assets/135639288/ff4cb72e-08b0-4ce3-9ef2-8562c3365846) 

# **Debian 12 "Bookworm" with Xfce: My Configuration Journey**

In this article, I will walk you through my personal configuration steps for Debian 12, featuring the Xfce desktop environment. I’ll share my experiences, insights, and the reasons behind my choice of Xfce as my preferred working environment.

Debian 12, renowned for its stability and reliability, has long been a favorite among Linux users. Here, I will outline the various settings and enhancements I have made to tailor Debian 12 to my specific needs.

A significant focus will be on the Xfce desktop environment. I’ll explain why I chose Xfce over other options and the benefits it offers for daily use.

This article is designed to be helpful for both newcomers just starting with Debian and seasoned users looking for ways to further optimize their system to suit their unique requirements and preferences.

---


# 1. **Script for Automated Minimal Installation of Debian 12**

Automating the installation of Debian 12 in a minimal configuration can be done using a preseed file. Below is an example of such a file and instructions on how to use it.

---

#### **Preseed File (preseed.cfg):**

```plaintext
# Set the locale and keyboard layout
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us

# Network configuration
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string debian
d-i netcfg/get_domain string localdomain

# Mirror settings
d-i mirror/country string manual
d-i mirror/http/hostname string deb.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string

# Disk partitioning
d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/expert_recipe string                         \
      single ::                                               \
              1000 10000 1000000000 ext4                      \
                      $primary{ }                             \
                      method{ format } format{ }              \
                      use_filesystem{ } filesystem{ ext4 }    \
                      mountpoint{ / }                         \
              .
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# Install minimal set of packages
tasksel tasksel/first multiselect standard
d-i pkgsel/include string sudo git python3.11 python3-pip virtualenv vim

# Disable installation of recommended packages
d-i apt-setup/restricted boolean false
d-i apt-setup/universe boolean false
d-i pkgsel/install-recommends boolean false

# Set root password
d-i passwd/root-password password rootpassword
d-i passwd/root-password-again password rootpassword

# Create a user with sudo privileges
d-i passwd/user-fullname string User
d-i passwd/username string user
d-i passwd/user-password password userpassword
d-i passwd/user-password-again password userpassword
d-i usermod -aG sudo user
d-i user-setup/allow-password-weak boolean true

# Install the GRUB bootloader
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean false
d-i grub-installer/bootdev  string /dev/sda

# Finish installation
d-i finish-install/reboot_in_progress note
```

---

**Instructions for Using the Preseed File:**

1. **Save the file** above as `preseed.cfg`.

2. **Download the Debian 12 Netinst ISO** from the official website: [Debian Downloads](https://www.debian.org/distrib/netinst).

3. **Create a bootable USB drive** using a tool like Rufus or Etcher.

4. **Copy the `preseed.cfg` file** to the root of the USB drive or in the `/preseed/` directory.

5. **During boot from the USB drive**, at the initial installation screen, press `Tab` or `e` (depending on the bootloader) to modify boot parameters.

6. **Add the following parameters** to the boot line:

   ```
   auto=true priority=critical file=/cdrom/preseed.cfg
   ```

   This will tell the installer to use your preseed file for automated installation.

7. **Start the installation** by pressing `Enter`. The installation will proceed automatically without further input.

---

> [!NOTE]
> **Passwords and usernames** in the `preseed.cfg` file are shown in plain text. It is recommended to change them before use and store the file securely.
>
>  **Target disk** in the preseed file is set to `/dev/sda`. Make sure this is the correct disk for installation on your system.
>
>  **Packages to install** are listed in the line `d-i pkgsel/include string`. You can add or remove packages as desired.
>
> **Additional settings**, such as installing `node.js 20` and `openjdk-17-jdk-headless`, can be performed after the first system boot, as their installation requires additional repositories or commands.

---

**Installing Additional Packages After System Installation:**

After completing the minimal installation, you can install additional packages:

```bash
# Update the system
sudo apt update && sudo apt upgrade -y

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install OpenJDK 17 headless
sudo apt install -y openjdk-17-jdk-headless

# Configure environment variables for Java
echo 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

**Explanation:**

- **The preseed file** allows automating the Debian installation process with a minimal set of packages and configurations.
- **Installing additional packages post-installation** provides a more flexible approach, allowing you to tailor the system to your specific requirements.
- **Setting environment variables** for Java ensures that Java applications requiring `JAVA_HOME` work correctly.

&nbsp;

> [!IMPORTANT]
> Ensure you fully understand the process and potential risks of automated installation before beginning.
>
> It is recommended to test the installation in a virtual machine before deploying on real hardware.
> 
> Always back up important data before performing any installation.

---

&nbsp;

&nbsp;

# 2. Script for Deploying a Workstation Based on Debian 12


> This **preseed.cfg** file is an automated installation script for a ***Deploying a Workstation Based on Debian 12***, allowing the system to be configured without user intervention. Let's analyze each section of the file and explain its purpose:

&nbsp;

#### 1. **Setting Locale and Keyboard Layout**

```plaintext
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us,ru
d-i keyboard-configuration/toggle select win+space
```

- **`locale string en_US.UTF-8`** — Sets the system locale to English (United States) with UTF-8 encoding.
- **`keyboard-configuration/xkb-keymap select us,ru`** — Configures the keyboard layouts to English (US) and Russian.
- **`keyboard-configuration/toggle select win+space`** — Sets the key combination (`Win+Space`) for switching keyboard layouts.

&nbsp;

#### 2. **Configuring Time Zone**

```plaintext
d-i time/zone string Europe/Warsaw
d-i clock-setup/utc boolean true
```

- **`time/zone string Europe/Warsaw`** — Sets the system time zone to `Europe/Warsaw`.
- **`clock-setup/utc boolean true`** — Indicates that the system clock is set to UTC time.

&nbsp;

#### 3. **Network Configuration with DHCP**

```plaintext
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string deb
d-i netcfg/get_domain string localdomain
d-i netcfg/dhcp_options select Configure network automatically
d-i netcfg/disable_dhcp boolean false
```

- **`netcfg/choose_interface select auto`** — Automatically selects the network interface to use.
- **`netcfg/get_hostname string deb`** — Sets the system hostname to `deb`.
- **`netcfg/get_domain string localdomain`** — Sets the default domain name to `localdomain`.
- **`netcfg/dhcp_options select Configure network automatically`** — Configures the network automatically using DHCP.
- **`netcfg/disable_dhcp boolean false`** — Indicates that DHCP is enabled (i.e., not disabled).

&nbsp;

#### 4. **Mirror Repository Settings**

```plaintext
d-i mirror/country string manual
d-i mirror/http/hostname string deb.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string
```

- **`mirror/country string manual`** — Sets manual selection of the mirror repository country.
- **`mirror/http/hostname string deb.debian.org`** — Specifies the main Debian mirror repository.
- **`mirror/http/directory string /debian`** — Path to the repository directory.
- **`mirror/http/proxy string`** — Leaves the proxy parameter empty, meaning no proxy is used.

&nbsp;

#### 5. **Disk Partitioning**

```plaintext
d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/expert_recipe string                         \
      boot-root ::                                            \
              100 200 100 ext4                                \
                      $primary{ } $bootable{ }                \
                      method{ format } format{ }              \
                      use_filesystem{ } filesystem{ ext4 }    \
                      mountpoint{ / }                         \
              .                                               \
              512 10000 1000000000 ext4                       \
                      method{ keep }                          \
              .
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
```

- **`partman-auto/disk string /dev/sda`** — Specifies the disk (`/dev/sda`) for automatic partitioning.
- **`partman-auto/method string regular`** — Selects the standard partitioning method.
- **`partman-auto/choose_recipe select atomic`** — Chooses the `atomic` partitioning recipe.
- **`partman-auto/expert_recipe`** — Defines a custom partitioning recipe:
  - Creates two partitions: one for boot and the main (`/`) partition.
  - **`100 200 100 ext4`** — Sets the partition size from 100 to 200 MB with the `ext4` filesystem.
  - **`method{ format }`** — Formats the partition.
  - **`use_filesystem{ } filesystem{ ext4 }`** — Uses the `ext4` filesystem.
  - **`mountpoint{ / }`** — Mounts the root partition.
- **`partman/confirm_write_new_label boolean true`** — Confirms writing the new partition label.
- **`partman/choose_partition select finish`** — Finishes partition selection.
- **`partman/confirm boolean true`** — Confirms the changes to the disk partitioning.
- **`partman/confirm_nooverwrite boolean true`** — Confirms the installation even if there is unsaved data.

&nbsp;

#### 6. **Installing the Minimum Set of Packages**

```plaintext
tasksel tasksel/first multiselect standard
d-i pkgsel/include string sudo git python3.11 python3-pip virtualenv nano unattended-upgrades \
    firmware-linux firmware-linux-nonfree firmware-iwlwifi firmware-realtek firmware-atheros \
    alsa-utils pulseaudio pavucontrol network-manager network-manager-gnome wpasupplicant \
    cheese xserver-xorg-input-all xserver-xorg-video-all xorg xfce4 xfce4-terminal lightdm lightdm-gtk-greeter \
    openssh-client curl wget mc firefox-esr nftables firewalld snort suricata ossec-hids fail2ban
```

- **`tasksel/first multiselect standard`** — Selects the installation of the standard set of packages.
- **`pkgsel/include string ...`** — Specifies additional packages to be installed:
  - **`sudo, git, python3.11, python3-pip, virtualenv`** — Administration and development tools.
  - **`nano`** — Text editor.
  - **`unattended-upgrades`** — Automatic security updates.
  - **`firmware-*`** — Drivers for various devices (e.g., Wi-Fi).
  - **`alsa-utils, pulseaudio, pavucontrol`** — Packages for sound management.
  - **`network-manager, network-manager-gnome, wpasupplicant`** — Network management and Wi-Fi tools.
  - **`cheese`** — Software for webcam use.
  - **`xserver-xorg-input-all, xserver-xorg-video-all, xorg`** — Packages for X server installation.
  - **`xfce4, xfce4-terminal`** — XFCE4 desktop environment and terminal.
  - **`lightdm, lightdm-gtk-greeter`** — Display manager and its graphical greeter.
  - **`openssh-client, curl, wget, mc, firefox-esr`** — Tools for remote access, downloading, and browser.
  - **`nftables, firewalld`** — Firewall management tools.
  - **`snort, suricata, ossec-hids, fail2ban`** — Intrusion Detection Systems (IDS).

&nbsp;

#### 7. **Disabling the Installation of Recommended Packages**

```plaintext
d-i apt-setup/restricted boolean false
d-i apt-setup/universe boolean false
d-i pkgsel/install-recommends boolean false
```

- Disables the installation of recommended packages:
  - **`restricted`** and **`universe`** — Disables repositories with restricted packages.
  - **`install-recommends`** — Disables the installation of recommended packages.

&nbsp;

#### 8. **Disabling Root Login**

```plaintext
d-i passwd/root-login boolean false
d-i passwd/make-user boolean true
```

- **`passwd/root-login boolean false`** — Disables direct login as the `root` user.
- **`passwd/make-user boolean true`** — Creates a regular user.

&nbsp;

#### 9. **Creating a User with Sudo Rights**

```plaintext
d-i passwd/user-fullname string ssobol7
d-i passwd/username string ssobol7
d-i passwd/user-password password qwerty
d-i passwd/user-password-again password qwerty
d-i passwd/expire password true
d-i usermod -aG sudo ssobol7
d-i user-setup/allow-password-weak boolean true
```

- Creates a user `ssobol7` with `sudo` rights and a temporary password `qwerty`.
- **`passwd/expire password true`** — Requires the password to be changed at first login.
- **`user-setup/allow-password-weak boolean true`** — Allows a weak password.

&nbsp;

#### 10. **Setting Up Automatic Security Updates**

```plaintext
d-i pkgsel/update-policy select unattended-upgrades
```

- **`pkgsel/update-policy select unattended-upgrades`** — Enables automatic security updates.

&nbsp;

#### 11. **GRUB Bootloader Installation**

```plaintext
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean false
d-i grub-installer/bootdev  string /dev/sda
```

- **`grub-installer/only_debian boolean true`** — Installs the GRUB bootloader only for Debian.
- **`grub-installer/with_other_os boolean false`** — Does not search

 for other operating systems.
- **`grub-installer/bootdev string /dev/sda`** — Installs GRUB on the `/dev/sda` disk.

&nbsp;

#### 12. **Configuring the `sources.list` File**

```plaintext
d-i preseed/late_command string "echo 'deb http://deb.debian.org/debian bookworm main non-free-firmware' > /target/etc/apt/sources.list; \
echo 'deb-src http://deb.debian.org/debian bookworm main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb http://security.debian.org/debian-security bookworm-security main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb http://deb.debian.org/debian bookworm-updates main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb-src http://deb.debian.org/debian bookworm-updates main non-free-firmware' >> /target/etc/apt/sources.list;"
```

- Uses `late_command` to configure repositories in the `/etc/apt/sources.list` file:
  - Sets up main repositories and their source repositories.
  - Enables security and update repositories.

&nbsp;

#### 13. **Configuring `Firewalld` for Workstation Mode**

```plaintext
d-i preseed/late_command string "systemctl enable firewalld; systemctl start firewalld; firewall-cmd --set-default-zone=work;"
```

- Automatically enables and configures `Firewalld` for "Workstation" mode.

&nbsp;

#### 14. **Setting Up IDS After Installation**

```plaintext
d-i preseed/late_command string "systemctl enable snort; systemctl start snort; systemctl enable suricata; systemctl start suricata; systemctl enable ossec-hids; systemctl start ossec-hids; systemctl enable fail2ban; systemctl start fail2ban;"
```

- Enables and starts intrusion detection systems (`Snort`, `Suricata`, `OSSEC`, `Fail2ban`) after installation.

&nbsp;

#### 15. **Finishing Installation**

```plaintext
d-i finish-install/reboot_in_progress note
```

- Completes the installation process, including system reboot.
&nbsp;

> [!NOTE]
> This `preseed.cfg` file provides a fully automated installation of Debian with a basic desktop configuration and security tools, including IDS, firewall, and essential utilities for full-stack development.

---

&nbsp;

### Preseed Configuration File for Workstation on Debian 12

```plaintext
# Setting locale and keyboard layout
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us,pl
d-i keyboard-configuration/toggle select win+space

# Configuring time zone
d-i time/zone string Europe/Warsaw
d-i clock-setup/utc boolean true

# Network configuration with DHCP
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string deb
d-i netcfg/get_domain string localdomain
d-i netcfg/dhcp_options select Configure network automatically
d-i netcfg/disable_dhcp boolean false

# Mirror repository settings
d-i mirror/country string manual
d-i mirror/http/hostname string deb.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string

# Disk partitioning
d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/expert_recipe string                         \
      single ::                                               \
              1000 10000 1000000000 ext4                      \
                      $primary{ }                             \
                      method{ format } format{ }              \
                      use_filesystem{ } filesystem{ ext4 }    \
                      mountpoint{ / }                         \
              .
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# Installing the minimum set of packages
tasksel tasksel/first multiselect standard
d-i pkgsel/include string sudo git python3.11 python3-pip virtualenv nano unattended-upgrades \
    firmware-linux firmware-linux-nonfree firmware-iwlwifi firmware-realtek firmware-atheros \
    alsa-utils pulseaudio pavucontrol network-manager network-manager-gnome wpasupplicant \
    cheese xserver-xorg-input-all xserver-xorg-video-all xorg xfce4 xfce4-terminal lightdm lightdm-gtk-greeter \
    openssh-client curl wget mc firefox-esr nftables firewalld snort suricata ossec-hids fail2ban

# Disabling installation of recommended packages
d-i apt-setup/restricted boolean false
d-i apt-setup/universe boolean false
d-i pkgsel/install-recommends boolean false

# Disabling root login
d-i passwd/root-login boolean false
d-i passwd/make-user boolean true

# Creating a user SCO with sudo rights
d-i passwd/user-fullname string sco
d-i passwd/username string sco
d-i passwd/user-password password qwerty
d-i passwd/user-password-again password qwerty
d-i passwd/expire password true
d-i usermod -aG sudo sco
d-i user-setup/allow-password-weak boolean true

# Setting up automatic security updates
d-i pkgsel/update-policy select unattended-upgrades

# Installing the GRUB bootloader
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean false
d-i grub-installer/bootdev  string /dev/sda

# Configuring the sources.list file
d-i preseed/late_command string "echo 'deb http://deb.debian.org/debian bookworm main non-free-firmware' > /target/etc/apt/sources.list; \
echo 'deb-src http://deb.debian.org/debian bookworm main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb http://security.debian.org/debian-security bookworm-security main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb http://deb.debian.org/debian bookworm-updates main non-free-firmware' >> /target/etc/apt/sources.list; \
echo 'deb-src http://deb.debian.org/debian bookworm-updates main non-free-firmware' >> /target/etc/apt/sources.list;"

# Configuring Firewalld for Workstation mode
d-i preseed/late_command string "systemctl enable firewalld; systemctl start firewalld; firewall-cmd --set-default-zone=work;"

# Configuring IDS after installation
d-i preseed/late_command string "systemctl enable snort; systemctl start snort; systemctl enable suricata; systemctl start suricata; systemctl enable ossec-hids; systemctl start ossec-hids; systemctl enable fail2ban; systemctl start fail2ban;"

# Finishing installation
d-i finish-install/reboot_in_progress note
```

> [!NOTE]
> **This file automates the installation of a Debian 12 workstation with specific settings for locale, keyboard layout, time zone, network configuration, disk partitioning, package selection, security, and post-installation configuration for firewall and intrusion detection systems (IDS).***

&nbsp;

---

&nbsp;

