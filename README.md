# Programming Assignment Zero (First Draft)

##### CSCI 2753: Operating Systems, String 2018

## Introduction:

This assignment will guide you through the setup of the Pi3 that will be used in class. The goal of this assignment is to get your Pi3 ready for programming assignment one.

You will need the following materials:

1. Pi 3
2. A 8 GB mini SD card
3. A SD to mini SD adapter (if you don't have one, borrow one from your TA)
4. A computer that has a SD card reader or a USB to SD card reader adapter

> **NOTE:** Pi2 can be used but a wired connect is needed at all times!

## Step 1: Writing image to SD card

We will cover two ways to write the image to a SD card. One method is to use Etcher, a tool that allows you to flash OS images to SD cards. Etcher works on Windows, MacOS, and Linux. The other is a more advance way using the command line (CLI) on a Linux system. First we will cover Etcher, then the more advanced `dd` command.

> **NOTE:** If you are using Windows or MacOS you have to use Etcher.

## Step 2: Using Etcher (Easy method)

First you need to download Etcher. You can do this by clicking [here](https://etcher.io/) ...

(NOT FINISHED)

## Step 2: Using `dd` command (Advanced method, Linux only)

> **NOTE:** You can skip this step if you completed *Step 2: Using Etcher (Easy method)*.

To use the `dd` command you will have to be on Linux and have root privileges. There are well written instructions on the pi website [here](https://www.raspberrypi.org/documentation/installation/installing-images/linux.md) or you can use the instructions below.

> **WARNING:** The `dd` command is very powerful and if used inappropriately is able to wipe all the data from your hard drive. Make sure to read the instructions carefully. Note, displayed information may vary depending on your system setup.

(NOT FINISHED)

After inserting the SD card into the computer, use the `lsblk` command to list the block devices.

```bash
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 119.2G  0 disk
├─sda1        8:1    0   512M  0 part /boot/efi
└─sda2        8:2    0 118.8G  0 part /
mmcblk0     179:0    0  14.9G  0 disk
├─mmcblk0p1 179:1    0  43.1M  0 part /media/demu/boot
└─mmcblk0p2 179:2    0   1.7G  0 part /media/demu/rootfs
```

If the SD card is partitioned, Linux will mount them automatically. Before writing the new image unmount the partitions with the following commands:
```bash
$ sudo umount /media/demu/boot
$ sudo umount /media/demu/rootfs
```
Run the `lsblk` command again. The `MOUNTPOINT` fields will be empty.

```bash
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda           8:0    0 119.2G  0 disk
├─sda1        8:1    0   512M  0 part /boot/efi
└─sda2        8:2    0 118.8G  0 part /
mmcblk0     179:0    0  14.9G  0 disk
├─mmcblk0p1 179:1    0  43.1M  0 part
└─mmcblk0p2 179:2    0  14.8G  0 part
```
Now write the image to the SD card. It is very important that you **DON'T** specify a partition (`mmcblk0p1` or `mmcblk0p2`). You write the image to the device (`mmcblk0`) as shown below.

```bash
$ sudo dd of=/dev/mmcblk0 if=2018-04-18-raspbian-stretch-lite.img bs=4M conv=fsync
```

(NOT FINISHED)

## Step 3: Before you plug your SD card into Pi

There are a few more steps needed before you can plug in your SD card into Pi.

### Step 3.1: Enabling ssh on boot (no monitor)

> **NOTE:** This step can be skipped if you have a monitor connected to your Pi.

After writing image to your SD, unplug and plug your SD card back into your computer. Two partition will be mounted, `/media/demu/boot` and `/media/demu/rootfs`. Add an empty file to the `/media/demu/boot` partition, name it `ssh`.

```bash
cd /media/demu/boot
touch ssh
```

 This will enable `ssh` by default (Pi only checks for this file on the first boot). This is useful if we don't have a monitor to login and enable `ssh` manually.

## Step 4: Setting up WiFi

To set up WiFi we will need a wired internet connection. Check if the Pi has an ip address on our ethernet.

```bash
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether b8:27:eb:1e:07:b5 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.105/24 brd 192.168.1.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::a6b3:b6ac:6a77:57ed/64 scope link
       valid_lft forever preferred_lft forever
3: wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN group default qlen 1000
    link/ether b8:27:eb:4b:52:e0 brd ff:ff:ff:ff:ff:ff
```
Our ethernet connection `eth0` has an ip address of `192.168.1.105`. First you want to update Pi's repository list and download the updates with the following command:

```bash
$ sudo apt update && sudo apt -y upgrade
```
Next, we want to install new network manager.

```bash
$ sudo apt install network-manager
```
Next, we install vim.

```bash
$ sudo apt install vim
```

Next, you need to disable the old network manager

```bash
$ sudo systemctl disable dhcpcd.service
```
Next, you need to stop the old network manager, dhcpcd

```bash
$ sudo systemctl stop dhcpcd.service
```

Make sure that dhcpcd is disable and stopped with `systemctl status dhcpcd.service` command.

```bash
$ sudo systemctl status dhcpcd.service
● dhcpcd.service - dhcpcd on all interfaces
   Loaded: loaded (/lib/systemd/system/dhcpcd.service; disabled; vendor preset: enabled)
  Drop-In: /etc/systemd/system/dhcpcd.service.d
           └─wait.conf
   Active: inactive (dead) since Fri 2018-05-18 05:12:30 UTC; 3s ago
  Process: 6379 ExecStop=/sbin/dhcpcd -x (code=exited, status=0/SUCCESS)
 Main PID: 558 (code=exited, status=0/SUCCESS)

May 18 05:10:21 raspberrypi dhcpcd[558]: wlan0: new hardware address: 7e:1e:ce:10:7d:0c
May 18 05:12:29 raspberrypi systemd[1]: Stopping dhcpcd on all interfaces...
May 18 05:12:29 raspberrypi dhcpcd[6379]: sending signal TERM to pid 558
May 18 05:12:29 raspberrypi dhcpcd[6379]: waiting for pid 558 to exit
May 18 05:12:29 raspberrypi dhcpcd[558]: received SIGTERM, stopping
May 18 05:12:29 raspberrypi dhcpcd[558]: wlan0: removing interface
May 18 05:12:29 raspberrypi dhcpcd[558]: eth0: removing interface
May 18 05:12:30 raspberrypi dhcpcd[6379]: sending signal TERM to pid 558
May 18 05:12:30 raspberrypi dhcpcd[6379]: waiting for pid 558 to exit
May 18 05:12:30 raspberrypi systemd[1]: Stopped dhcpcd on all interfaces.
```
On the third line that starts with `Loaded:` notice that it states `disabled`. The *disabled* status will make sure the dhcpcd network manager will not start on reboot, alternatively, *stopped* will stop it from running as indicated on the sixth line that starts with `Active:`; its status is `inactive (dead)`

(Next step will be to take the interface down but since I don't have a monitor I can't test this)

The line `managed=false` need to be changed to `managed=true` in `NetworkManager.conf` ie:

```bash
$ cat /etc/NetworkManager/NetworkManager.conf
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=false
```
To:

```bash
$ cat /etc/NetworkManager/NetworkManager.conf
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
```
Run command:

```bash
$ sudo nmtui
```
Will open a text based GUI:

```bash
┌─┤ NetworkManager TUI ├──┐
│                         │
│ Please select an option │
│                         │
│ Edit a connection       │
│ Activate a connection   │
│ Set system hostname     │
│                         │
│ Quit                    │
│                         │
│                    <OK> │
│                         │
└─────────────────────────┘
```
Select `Edit a connection` then `<Add>`. Then select `Wi-Fi` from the list.

On the security portion, if the router is using the default `WPA2-PSK [AES]` then:

```bash
┌───────────────────────────┤ Edit Connection ├───────────────────────────┐
│                                                                        ↑│
│         Profile name Wi-Fi-Home______________________________          ▮│
│               Device wlan0 (B8:27:EB:4B:52:E0)_______________          ▒│
│                                                                        ▒│
│ ╤ WI-FI                                                       <Hide>   ▒│
│ │               SSID NETGEAR_________________________________          ▒│
│ │               Mode <Client>                                          ▒│
│ │                                                                      ▒│
│ │           Security <WPA & WPA2 Personal>                             ▒│
│ │           Password **************__________________________          ▒│
│ │                    [ ] Show password                                 ▒│
│ │                                                                      ▒│
│ │              BSSID ________________________________________          ▒│
│ │ Cloned MAC address ________________________________________          ▒│
│ │                MTU __________ (default)                              ▒│
│ └                                                                      ▒│
│                                                                        ▒│
│ ═ IPv4 CONFIGURATION <Automatic>                              <Show>   ▒│
│ ═ IPv6 CONFIGURATION <Automatic>                              <Show>   ▒│
│                                                                        ↓│
└─────────────────────────────────────────────────────────────────────────┘
```

(Here students can add there home connect and once they plug power to their pi their home router should automatically connect and send the ip to slack.)

```bash
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether b8:27:eb:1e:07:b5 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.105/24 brd 192.168.1.255 scope global dynamic eth0
       valid_lft 86379sec preferred_lft 86379sec
    inet6 fe80::6caa:14e1:c0ba:104a/64 scope link
       valid_lft forever preferred_lft forever
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether b8:27:eb:4b:52:e0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.4/24 brd 192.168.1.255 scope global dynamic wlan0
       valid_lft 86379sec preferred_lft 86379sec
    inet6 fe80::7bf0:43e5:64fc:415f/64 scope link
       valid_lft forever preferred_lft forever
```
WiFi works!
