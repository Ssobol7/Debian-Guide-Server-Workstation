## **Mounting USB Drives with Different Filesystems (NTFS, UFS, FAT32, Btrfs, ZFS) on Linux**

&nbsp;

> How to mount USB drives with different filesystems on Linux.


&nbsp;

### Step 1: Identify the Connected Device

First, you need to determine which device represents your USB drive.

1. Connect the USB drive to your computer.
2. Run the following command in the terminal to display all connected devices:

```bash
$ lsblk
```

**Example output of `lsblk`:**

```bash
$ lsb
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 465.8G  0 disk 
├─sda1   8:1    0   100M  0 part /boot/efi
├─sda2   8:2    0   250G  0 part /
└─sda3   8:3    0 215.7G  0 part /home
sdb      8:16   1  14.5G  0 disk 
└─sdb1   8:17   1  14.5G  0 part /media/usb
```

In this example, the USB drive is represented by the device `sdb`, and the partition is `sdb1`.

### Step 2: Identify the Filesystem on the USB Drive

To find out the filesystem on the USB drive, run the following command:

```bash
$ sudo blkid /dev/sdb1
```

**Example output:**

```bash
/dev/sdb1: LABEL="MyDrive" UUID="1234-5678" TYPE="ntfs" PARTUUID="abcd1234"
```

In this case, the filesystem type is **NTFS**.

### Step 3: Install Required Packages for Mounting Filesystems

To properly mount various filesystems, you may need to install the following packages:

- **NTFS** — `ntfs-3g`
- **UFS** — UFS support is built into the Linux kernel, but you might need to install the `ufsutils` package.
- **FAT32** — Support is built-in, no additional software required.
- **Btrfs** — Install the `btrfs-progs` package.
- **ZFS** — Install `zfsutils-linux` and `zfs-fuse` packages.

Install the necessary packages:

```bash
# For NTFS
$ sudo apt install ntfs-3g

# For UFS
$ sudo apt install ufsutils

# For Btrfs
$ sudo apt install btrfs-progs

# For ZFS
$ sudo apt install zfsutils-linux zfs-fuse
```

### Step 4: Mount the USB Drive


#### **Mounting an NTFS Drive**

1. Create a mount point:

   ```bash
   $ sudo mkdir /mnt/ntfs-usb
   ```

2. Mount the drive:

   ```bash
   $ sudo mount -t ntfs-3g /dev/sdb1 /mnt/ntfs-usb
   ```

3. To unmount the drive, use:

   ```bash
   $ sudo umount /mnt/ntfs-usb
   ```

#### **Mounting a UFS Drive**

1. Create a mount point:

   ```bash
   $ sudo mkdir /mnt/ufs-usb
   ```

2. Mount the drive:

   ```bash
   $ sudo mount -t ufs -o rw,ufstype=ufs2 /dev/sdb1 /mnt/ufs-usb
   ```

3. To unmount the drive, use:

   ```bash
   $ sudo umount /mnt/ufs-usb
   ```

#### **Mounting a FAT32 Drive**

1. Create a mount point:

   ```bash
   $ sudo mkdir /mnt/fat32-usb
   ```

2. Mount the drive:

   ```bash
   $ sudo mount -t vfat /dev/sdb1 /mnt/fat32-usb
   ```

3. To unmount the drive, use:

   ```bash
   $ sudo umount /mnt/fat32-usb
   ```

#### **Mounting a Btrfs Drive**

1. Create a mount point:

   ```bash
   $ sudo mkdir /mnt/btrfs-usb
   ```

2. Mount the drive:

   ```bash
   $ sudo mount -t btrfs /dev/sdb1 /mnt/btrfs-usb
   ```

3. To unmount the drive, use:

   ```bash
   $ sudo umount /mnt/btrfs-usb
   ```

#### **Mounting a ZFS Drive**

1. Import the ZFS pool:

   ```bash
   $ sudo zpool import
   ```

2. Mount the drive:

   ```bash
   $ sudo zfs mount /dev/sdb1 /mnt/zfs-usb
   ```

3. To unmount the drive, use:

   ```bash
   $ sudo zfs umount /mnt/zfs-usb
   ```

### Step 5: Automatic Mounting

To automatically mount the USB drive upon connection, you can add it to the `/etc/fstab` file. Here’s an example of how to add an entry:

```bash
/dev/sdb1  /mnt/ntfs-usb  ntfs-3g  defaults  0  0
```

&nbsp; 

> Attantion!
> 
> Be sure to unmount devices after use to avoid data corruption.

---

&nbsp; 
