# Programming Assignment Zero - Virtual Machine (First Draft)

##### CSCI 2753: Operating Systems, 2018

## Introduction:

This assignment will guide you through the setup of the Virtual Machine that will be used in class. The goal of this assignment is to get your VM ready for programming assignment one.


## Step 1: Download VMWare

We will be using a command line only version of Linux within a Virtual Machine.  You may need to download the [Virtual Machine Host Software](https://www.vmware.com/) to your system if you have not already done it for another course. This is the hypervisor that we will use for the course.  

See the [Foundation website for CU Computer Science](
https://foundation.cs.colorado.edu/vm/#install) to access the hypervisor software.


## Step 2: Download VM image from CU Website

Download the zip file for the CU CS Virtual Machine from [CU Foundation Website](https://foundation.cs.colorado.edu/vm/#obtain).

Extract the image file (\*.ovf) from the zipped file.


See the [installation guide](
https://foundation.cs.colorado.edu/vm/#install) to install the VM into the hypervisor.  Once your VM is installed you can use that version or create a [clone](https://foundation.cs.colorado.edu/vm/#usage) of the VM.  Each time you add software or changes to the OS and get them working, you may want to clone the VM in case the original VM gets corrupted by further changes.  The clone can run and if you corrupt it, you can back out those changes without rebuilding everything, if you make backups.

  Remember that if you cause a VM to crash, you may corrupt the file system or disk data.  Make sure you are using good backup practices to make sure your code and other files are duplicated elsewhere (Dropbox, GIT).

## Step 3: Setting up the VM

Most of the files and software should already be installed on the virtual machine image. It is important that you do not update the operating system as all the assignments are designed and written using the software versions with which the VM has been distributed. However, not all the required components have been previously installed.  Here we provide the steps to finish setting up your VM.

To update to the latest files provided by CS Foundations, run the following command to access and install all the necessary packages required for the course.

```text
 run sudo apt-get install cu-cs-csci-3753
 ```

## Step 4: Configuring the Grub (Boot Loader)
Grub is the boot loader installed with Ubuntu 14.04. It provides configuration options to boot from a list of different kernels available on the machine. By default Ubuntu 14.04 suppresses much of the boot process from users; as a result, we will need to update our Grub configuration to allow booting from multiple kernel versions and to recover from a corrupt installation. Perform the following:

Figure 1: Linux Grub Boot Menu

### Step 4.1:
From the command line, load the grub configuration file:
```text
sudo vi /etc/default/grub
```
(feel free to replace `vi` with the editor of your choice).

### Step 4.2:
Make the following changes to the configuration file:
```text
1. Comment out:
       GRUB_HIDDEN_TIMEOUT=0

2.  Comment out:
       GRUB_HIDDEN_TIMEOUT_QUIET=true

3. Comment out:
       GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
   and add the following new line directly below it:
       GRUB_CMDLINE_LINUX_DEFAULT=""

4.  Save updates
```

### Step 4.3:
From the command line, update Grub:
```text
sudo update-grub.
```

### Step 4.4:
Reboot your virtual machine and verify you see a boot menu as shown in Figure 1.

## Step 5. Downloading Linux Source Code
First, you have to download the linux source code that you will be using for this assignment where you will be adding your new system call, compiling the source and then running the kernel with the added system call. For this execute the following commands in the terminal.

```text
1. cd /home
2. sudo mkdir kernel
3. cd kernel
4. sudo apt-get source linux-image-$(uname -r)
```

The command `uname –r` gives you the current version of the kernel you are using. So that means you are downloading the same kernel as your current kernel. The command `uname –a` will give you the system architecture information (for example if your OS is 32 or 64 bit).  


## Step 6. Compiling the Kernel

### Step 6.1:  
Typically it takes a long time to compile (2-3) hours to compile the kernel source code. To get around this, install `ccache` by running the following command:
```text
sudo apt-get install ccache
```
ccache is a compiler `cache`. It is used to speed up recompilation by caching previous compilations and detecting when the same compilation is being done again. The first compilation will take the usual long time but after you make the necessary changes, the recompilations will be much faster after you install `ccache`.

### Step 6.2:
Now you have to change permission of the debian scripts required to compile the source code. Just run the following commands in the linux source code directory.

```text
sudo chmod a+x debian/scripts/*
sudo chmod a+x debian/scripts/misc/*
```

or alternatively you can execute all the commands using sudo.


### Step 6.3:

The next step is to create the config file.
```text
sudo make localmodconfig
```
command will create the config file. Run the command in the linux source directory you downloaded and extracted.

### Step 6.4:

In the same folder, execute the command
```text
sudo make menuconfig
```
A pop up will be generated. Select the general set up (Figure 2)  and then select the option append to the release (Figure 3) and enter the name you want to give to the kernel you will be compiling ,installing and running (for example revision1). This name will appear when you reboot and from the grub  you can select it and check your new system call.


Figure 2: Configuring the menuconfig


Figure 3: Configuring the menuconfig



### Step 6.5:

Now just run the following commands:
```text
sudo make -j2 CC="ccache gcc"
sudo make -j2 modules_install
sudo make -j2 install
sudo reboot
```

When the grub option shows up, select the version you have installed with the new name appended.

Notes:
On some systems we have encountered build errors using the default command sequence listed above.  You may encounter VM related errors. The files under the ubuntu directory are assumed to be included only in the ubuntu kernel. This problem is caused by not finding the header file correctly.

[Error]								
cc1: fatal error: ./ubuntu/vbox/vboxguest/include/VBox/VBoxGuestMangling.h: No such file or directory
compilation terminated.
scripts / Make!le.build: 258: recipe for target ‘ubuntu / vbox / vboxguest / VBoxGuest-linux.o’ failed

[Commands to remedy this error]					
cd ubuntu/vbox
ln -s ../include ./r0drv/include
ln -s ../include ./vboxsf/include
ln -s ../include ./vboxguest/include
ln -s ../include ./vboxvideo/include
sudo make -j2 CC="ccache gcc"

[Error]						
make [4]: *** No rule to make target ‘ubuntu / vbox / vboxguest / vboxguest / r0drv / alloc-r0drv.o’, needed by ‘ubuntu / vbox / vboxguest / vboxguest.o’. Stop.

[Command]					
cd ubuntu/vbox/vboxguest
ln -s ../r0drv/
sudo make -j2 CC="ccache gcc" 					


http://technote.thispage.me/index.php/2016/12/20/ubuntu-16-04-kernel-compile-on-default-setting/
