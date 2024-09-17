![deb](https://github.com/Ssobol7/Debian-12-Xfce-My-Config/assets/135639288/ff4cb72e-08b0-4ce3-9ef2-8562c3365846) 

# **Debian 12 "Bookworm" with Xfce: My Configuration Journey**

In this article, I will walk you through my personal configuration steps for Debian 12, featuring the Xfce desktop environment. I’ll share my experiences, insights, and the reasons behind my choice of Xfce as my preferred working environment.

Debian 12, renowned for its stability and reliability, has long been a favorite among Linux users. Here, I will outline the various settings and enhancements I have made to tailor Debian 12 to my specific needs.

A significant focus will be on the Xfce desktop environment. I’ll explain why I chose Xfce over other options and the benefits it offers for daily use.

This article is designed to be helpful for both newcomers just starting with Debian and seasoned users looking for ways to further optimize their system to suit their unique requirements and preferences.

---


# **Script for Automated Minimal Installation of Debian 12**

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

# Install minimal set of packages
tasksel tasksel/first multiselect standard
d-i pkgsel/include string sudo git python3.11 python3-pip virtualenv nano

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

**Notes:**

- **Passwords and usernames** in the `preseed.cfg` file are shown in plain text. It is recommended to change them before use and store the file securely.
- **Target disk** in the preseed file is set to `/dev/sda`. Make sure this is the correct disk for installation on your system.
- **Packages to install** are listed in the line `d-i pkgsel/include string`. You can add or remove packages as desired.
- **Additional settings**, such as installing `node.js 20` and `openjdk-17-jdk-headless`, can be performed after the first system boot, as their installation requires additional repositories or commands.

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

---

**Important:**

- Ensure you fully understand the process and potential risks of automated installation before beginning.
- It is recommended to test the installation in a virtual machine before deploying on real hardware.
- Always back up important data before performing any installation.

  ---
  
