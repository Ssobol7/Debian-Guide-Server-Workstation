# How to create a bootable USB drive using `dd` on Linux?

&nbsp;

> [!NOTE]
> Using the `dd` command on Linux, you can easily create a bootable USB drive with the Debian ISO image.
> 
> It is important to be cautious and select the correct device (e.g., `/dev/sdb`) to avoid overwriting data on another drive.

&nbsp;

## **Creating a Bootable USB Drive Using `dd` on Linux**

&nbsp;

### Step 1: Download the Debian 12 ISO

1. Visit the [official Debian website](https://www.debian.org/distrib/netinst) and download the Debian 12 Netinst ISO image.

&nbsp;

### Step 2: Connect the USB Drive

1. Insert your USB drive into your computer.
2. Open a terminal and run the following command to view connected devices:

   ```bash
   lsblk
   ```

   **Example output of the `lsblk` command:**

   ```bash
   $ lsblk
   NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
   sda      8:0    0 465.8G  0 disk 
   ├─sda1   8:1    0   100M  0 part /boot/efi
   ├─sda2   8:2    0   250G  0 part /
   └─sda3   8:3    0 215.7G  0 part /home
   sdb      8:16   1  14.5G  0 disk 
   └─sdb1   8:17   1  14.5G  0 part /media/usb
   ```

   - In this example, you can see:
     - **sda** is the main hard drive (465.8GB).
     - **sdb** is the USB drive with a size of 14.5GB.

   **Important**: Make sure your USB drive is **sdb** or the appropriate device, as you will be writing the ISO image to this device.

&nbsp;

### Step 3: Unmount the USB Drive

Before writing the ISO image, ensure the device is unmounted. If it is mounted, unmount it using the following command:

```bash
sudo umount /dev/sdb1  # where sdb1 is your USB drive
```

&nbsp;

### Step 4: Write the ISO Image to the USB Drive Using `dd`

To write the ISO image to the USB drive, run the following command:

```bash
sudo dd if=/path/to/debian-12.7.0-amd64-netinst.iso of=/dev/sdb bs=4M status=progress oflag=sync
```

or, if you are using the DVD ISO:


```bash
sudo dd if=/path/to/debian-12.7.0-amd64-DVD-1.iso of=/dev/sdb bs=4M status=progress oflag=sync
```

**Explanation of the command:**
- **if=/path/to/debian-12.7.0-amd64-netinst.iso** — the path to the downloaded **Netinst ISO** image for Debian 12.7.
- **if=/path/to/debian-12.7.0-amd64-DVD-1.iso** — if you are using the **full DVD ISO** instead.
- **of=/dev/sdb** — the path to your USB drive (be careful to specify the correct device).
- **bs=4M** — block size (4MB for optimal speed).
- **status=progress** — shows the progress of the writing process.
- **oflag=sync** — ensures the data is fully written to the USB drive.

### Example output of the `dd` command:

```bash
6946816+0 records in
6946816+0 records out
3558793216 bytes (3.6 GB, 3.3 GiB) copied, 274.531 s, 13.0 MB/s
```

This output indicates how much data was written and the writing speed.

&nbsp;

### Step 5: Safely Remove the USB Drive

Once the writing process is complete, safely eject the USB drive with the following command:

```bash
sudo eject /dev/sdb
```

&nbsp;

**Your bootable USB drive is now ready to use. You can boot from it and install Debian 12 on your computer**

---

&nbsp;

