# Configure SSD support in Debian 12.1
 
## Configuring /etc/fstab

1. **/etc/fstab** is one of the important OS files that is executed during the system load.
   
   It describes what partitions of the drives and how exactly it is mounted in the OS file system. 

   *We open up:*

```
~$ gksu gedit /etc /fstab
```


2. Turn off swap


   If the **SSD** is purchased, you can add memory to the machine and turn off the swap. To do this, it will be enough already 4GiB (use free and top utilities to find out how much memory the OS consumes)

   If the memory is enough, put the system without a swap or turn it off if the system is already installed.

   *Comment on the swap line:*
   
```
UUID-xxxx-xxxx- nonex sap swap 0
```

3. If the memory for OS tasks is small, then we try to set the priority of using swap (see below)

   *Mounting options:*

```
UUID-eajeade6fd-2b24-4e59-bc8c-6f1791338b0c / ext4 noatime,discard,errors-remount-ro,mit?60 0
```

**discard** - Includes **TRIM** technology that distributes load on SSD

**noatime and nodiratime** - Thanks to these options, the OS will not record the time of the last access to files and folders

**commit-60** - disk access frequency


4. When installing **commit-60**, it is possible to lose data for the last 60 seconds. work with a sudden power off.

   *Put in RAM cache apt:*

```
tmpfs /var/cache/apt/archives tmpfs defaults 0
```


5. The *apt cache* will not be saved on the disk and when the packets are reinstalled, you will need to re-pump them out.

  *Disable disk cache in browsers:*

  > *Mozilla Firefox*
  >  Editing , Settings , Additional , Network , Check the Tick , Disable Automatic Cage Control, Set a value of 0.

  > *Opera*
  >  Ctrl+F12 , Extended , History , Disk Cache , Disabled

  > *Chromium / Chrome*
  > Unfortunately, this browser can not disable disk cache from GUI.
  > There are various ways to turn off the disk cache, varying degrees of cumenidity, I will not describe them here.



6. Setting up **/etc/sysctl.conf**

* Open **/etc/sysctl.conf:*

```
~$ sudo gedit /etc/sysctl.conf
```


7. Priority of use of **swap**


If the memory is not enough, then you can simply reduce the aggressiveness of swinging. In **/etc/sysctl.conf** add a line:

`vm.swappiness?10`


The parameter controls the percentage of free memory at which the swap will begin.
Although, if you have little RAM and you bought yourself an SSD, then you did not do the right thing.

Destroyed entry

The core will save the data waiting for the recording to the disk, and record them either with urgent need or after the time of the time. I chose 60 seconds for me.

Add to the end of the file:

vm.laptop_mode ? 5
vm.dirty_writeback_centisecs . . . . . . . . . . . . . . . . . 




For application of changes

sudo sysctl -p




or reboot the OS.

Checking TRIM support

sudo hdparm -I /dev/sdX - grep "TRIM supported"




sdX is your SSD.

Manual execution of TRIM

It is possible that for some reason the TRIM options may not be enabled, then you need to perform TRIM manually. It usually makes sense to perform this operation after TRIM activation using the discard mount option in /etc/fsbab. There is a small fstrim utility.

sudo fstrim / -v




The -v option will show in the command output how many bytes on the partition was ?ottrimalle:

/: 28166164480 bytes were trimmed




The operation takes a while and can last from a few seconds to a few minutes.
Checked the correct operation of the utility on the sections ext4, btrfs. The ntfs and reiserfs are not working.

EXT4 Settings

If you have a laptop or UPS, you can fearlessly disable logging, which will not only reduce the recording on the SSD, but also increase performance.
If you're working on a network, you should think several times before you disconnect the magazine, it doesn't write much to take a risk. Who knows for sure, write in the top on the forum.
Download in live and:

sudo tune2fs - O ?has_journal /dev/sdXY




sudo e2fsck -f /dev/sdXY




Where:


    X - letter of disk

    Y - section number