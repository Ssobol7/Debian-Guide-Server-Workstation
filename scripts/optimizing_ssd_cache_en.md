# Optimizing SSD Performance in Debian

![ssd](https://github.com/user-attachments/assets/ee21bcf6-46a6-43c7-ba39-e8acf3e419bc)

## Configuring `/etc/fstab`

> **`fstab`** is an important configuration file used during the system boot process. It describes which partitions and file system devices should be mounted and how they should be mounted.

Open the **`fstab`** file:

```bash
$ sudo vi /etc/fstab
```

### Disabling the Swap File

If you have installed an SSD, it makes sense to increase the amount of RAM and disable the swap file to reduce disk writes and improve system performance. Typically, 4 GB of RAM is sufficient for comfortable work, but it's recommended to assess your system's memory consumption using utilities like `free` and `top`.

If you have enough memory, you can install the system without a swap partition or disable it in an already installed system. To do this, comment out the swap line in the `/etc/fstab` file by adding a `#` at the beginning of the line:

```bash
#UUID=xxxx-xxxx-xxxx-xxxx      none    swap    sw      0       0
```

If the amount of RAM is insufficient for your tasks, it's recommended to adjust the swap usage priority (see below).

### Mount Options for SSD

In the `/etc/fstab` file, ensure that the root file system partition is mounted with options optimized for SSDs. For example:

```bash
UUID=aeade6fd-2b24-4e59-bc8c-6f1791338b0c / ext4 noatime,errors=remount-ro 0 1
```

Where:

- **noatime** — Prevents updating the file access time when they are read, reducing disk writes.

- **errors=remount-ro** — In case of file system errors, remounts the partition in read-only mode to avoid data loss.

#### Enabling TRIM for SSD

The TRIM command allows the operating system to inform the SSD about data blocks that are no longer in use and can be erased, helping to maintain SSD performance over time.

It's recommended to set up periodic execution of the `fstrim` command instead of using the `discard` option in `/etc/fstab`, which performs TRIM on every file deletion and can lead to decreased performance on some SSDs.

**Setting up periodic TRIM using systemd:**

```bash
$ sudo systemctl enable fstrim.timer
$ sudo systemctl start fstrim.timer
```

This configures automatic weekly execution of `fstrim`.

### Moving APT Cache to RAM

You can reduce disk writes by moving the APT package cache to RAM. Add the following line to `/etc/fstab`:

```bash
tmpfs   /var/cache/apt/archives   tmpfs   defaults   0   0
```

**Important:** In this case, the package cache will not be preserved between reboots, and when reinstalling packages, they will need to be downloaded again, which can increase network traffic and installation time.

### Disabling Disk Cache in Browsers

To reduce disk writes on the SSD, you can disable the disk cache in web browsers:

1. **Mozilla Firefox**

   - Open settings: **Menu** → **Options** → **Privacy & Security**.
   - Scroll down to the **Cookies and Site Data** section.
   - Click **Manage Data...** and delete existing data if necessary.
   - To completely disable the cache, use the setting in `about:config`:
     - Enter `about:config` in the address bar and press Enter.
     - Accept the risk warning.
     - In the search bar, type `browser.cache.disk.enable`.
     - Double-click the parameter to set its value to `false`.

2. **Google Chrome/Chromium**

   - There is no GUI option to completely disable the disk cache.
   - You can launch the browser with the command-line parameter:
     ```bash
     $ google-chrome --disk-cache-size=0
     ```
   - Or modify the launch parameters in the application shortcut.

3. **Opera**

   - Open settings: **Menu** → **Settings** → **Advanced** → **Browser**.
   - In the **System** section, you can adjust cache usage, but complete disabling may not be available.

### Configuring `/etc/sysctl.conf`

Open the **`/etc/sysctl.conf`** file to configure kernel parameters:

```bash
$ sudo vi /etc/sysctl.conf
```

#### Adjusting Swap Usage Priority

To reduce the frequency of swap usage when memory is low, you can adjust the `vm.swappiness` parameter. Add the following to the file:

```bash
vm.swappiness=10
```

The `vm.swappiness` value determines how aggressively the system will use swap space. The default value is usually 60. Reducing this value to 10 will make the system use swap less frequently, which is especially beneficial for SSDs to reduce wear.

#### Configuring Writeback Delay

You can adjust the writeback parameters to reduce the frequency of disk writes:

```bash
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
```

- **vm.dirty_ratio** — The maximum percentage of system memory that can be filled with dirty pages (data waiting to be written to disk) before the process is forced to write them out.

- **vm.dirty_background_ratio** — The percentage of memory at which the background writeback process will start flushing data to disk.

These settings allow the system to accumulate more data in memory before writing to disk, reducing the number of write operations.

### Applying Changes

To apply the new settings, execute:

```bash
$ sudo sysctl -p
```

Or reboot the system:

```bash
$ sudo reboot
```

---

## Additional Recommendations

- **Updating SSD Firmware:** Ensure that your SSD has the latest firmware from the manufacturer, which may include performance and reliability improvements.

- **Monitoring SSD Health:** Use utilities like `smartctl` to check the SSD's health and monitor SMART attributes.

- **Partition Alignment:** When partitioning the disk, ensure that partitions are aligned to SSD block boundaries, which can improve performance.

- **File System:** Use modern file systems like `ext4` or `btrfs`, which have optimizations for SSDs.

- **Backups:** Regularly back up important data, as SSDs, like any storage devices, can fail.

## Conclusion

By following these recommendations, you can optimize your SSD's performance in Debian, enhance its speed, and extend its lifespan. However, keep in mind that modern operating systems and SSDs are often already optimized to work together, so not all the listed settings may be necessary in your situation. Always carefully study the impact of changes before applying them.

---
