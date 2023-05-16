# Pistachio Linux rootfs 

This Git repository contains the files and scripts required to build a root filesystem of [Pistachio Linux](https://linux.pistasjis.net). 

## Building

You'll need the following packages installed on your system:

* `debootstrap`
* `sudo`

It is also recommended that you are running a Debian-based Linux distribution, such as Ubuntu, Debian or Pistachio Linux.

To build the root filesystem, run the following command:

```
./create-rootfs.sh
```

You'll see lots of things on your terminal! But just sit back and relax, it will take a while. 

Once it's done, the newly built rootfs will be available in the `build` directory, named like this: ``pistachio-YYYYmmdd.tar.gz``.

## Get Latest Rootfs from GitHub Actions Artifacts

You can also get a rootfs built from the latest commit from GitHub Actions. To do so, go to the [Actions tab](https://github.com/PistachioLinux/rootfs/actions), click on the latest workflow run, and then click on the `build` job. Then, click on the `Artifacts` tab, and download the `pistachio-artifact-YYYYmmdd` file. Inside the file, you'll find the rootfs file, named like this: ``pistachio-YYYYmmdd.tar.gz``.   

## Import Rootfs in WSL

If you want to import your rootfs in WSL, you can use the following command:

```
wsl --import <DistroName> <InstallLocation> <FileName>
```

So, for Pistachio Linux, it would be:

```
wsl --import PistachioLinux C:\Path\To\Where\You\Want\Pistachio\Files\To\Be\Wow\This\Is\Long C:\Path\To\Build\pistachio-YYmmdd.tar.gz
```