# Mac xhyve for local development

This project exists to satisfy my personal desire to work in a Debian Linux environment whilst still maintaining a useable and intuitive desktop environment. This project allows a person to maintain macOS as their primary desktop environment, whist having a lightweight virtualized Debian Linux environment for development.

# Installation instructions

## Install xhyve

This requires the [homebrew](https://brew.sh/) package manager for macOS.

Edit the keg for xhyve in homebrew

```
brew edit xhyve
```

Add the following lines to patch xhyve.

```patch
diff --git a/Formula/xhyve.rb b/Formula/xhyve.rb
index 6668fbc0ba..8a66685495 100644
--- a/Formula/xhyve.rb
+++ b/Formula/xhyve.rb
@@ -16,6 +16,11 @@ class Xhyve < Formula

   depends_on :macos => :yosemite

+  patch do
+    url "https://github.com/mist64/xhyve/pull/119.patch"
+    sha256 "95708821a85d216e3e6adfe0a6f85b435cc51a9969ec15c194de4e14d0ac45b3"
+  end
+
   def install
     args = []
     args << "GIT_VERSION=#{version}" if build.stable?
```

Install xhyve from `HEAD`

```
brew install --HEAD xhyve
```

## Download Debian

These instructions will download Debian 10 Buster. If you want a different version, including Ubuntu distros, then replace the URL with the resource for the desired version of Linux.

These commands assume you are in this repository.

```
wget http://ftp.nl.debian.org/debian/dists/buster/main/installer-amd64/current/images/netboot/mini.iso
wget http://ftp.nl.debian.org/debian/dists/buster/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux
wget http://ftp.nl.debian.org/debian/dists/buster/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz
```

## Creating a Debian virtual machine

Create a blank disk image that will be used to install Debian in to. This will create a ~130GB disk.

```
SIZE=4g
dd if=/dev/zero of=hdd.img bs=$SIZE count=32
```

Start Debian installation within xhyve.

```
sudo ./xhyve-install.sh
```

This will start a tmux session and begin the Debian installation process. Follow along with the on-screen prompts and configure the installation to your specific requirements.

When the main installation completes, do not let the VM restart! Once you are at the completed stage, we need to obtain the newly created Linux boot images.

Use `Ctrl+A` then `2` to switch to a shell.

```
chroot /target bash
ip a
python 3 -m http.server
```

Open a browser in macOS and navigate to the IP address of the xyhve virtual machine. In the web view, download the files `vmlinuz` and `initrd.img` and place them into this repository folder.

## Start Debian

I recommend using tmux shell and starting the Debian VM in a separate pane. This allows it to remain running beyond the life of your terminal. The process will also trap STDIN/OUT/ERROR so that terminal window will no longer be useuable outside of running Debian.

I usually have a separate tmux pane that I use to SSH into the Debian VM when running. YMMV.

```
sudo start.sh
```

# Alternatives

ChromeOS now supports a linux container natively. To avoid all the hassle of setting up this project, I recommend a Google PixelBook or Google PixelBook Go (or equivilent).

# TODO

- Currently there is no facility to share mounts between the host macOS environment and the Virtual Machine. Considered using MacFuse for this purpose but have not implemented a solution yet. The workaround is to create a large enough disk for the Linux environment to use.

# Credits

Much of the inspiration for this project would not have been possible without a very useful blog post by [Shengjing Zhu](https://zhsj.me/blog/view/xhyve-install-debian). Portions of this projects documentation are based in part or full on their original post.
