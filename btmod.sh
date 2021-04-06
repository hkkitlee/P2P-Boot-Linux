#!/bin/bash

mkdir ~/siteiso ~/sitetorrent ~/sitetmp

rclone mount orgsiteiso:  ~/siteiso --daemon
rclone mount orgsitetorrent:  ~/sitetorrent --daemon

rm ~/sitetmp/initrd*
rm ~/sitetmp/vmlinuz*

rsync --info=progress2 ~/siteiso/*standard.iso ~/sitetmp/

mount ~/sitetmp/*standard.iso /mnt

cp /mnt/live/vmlinuz* ~/sitetmp/
cp /mnt/live/initrd* ~/sitetmp/

umount /mnt

rm ~/sitetmp/*standard.iso



cd ~/sitetmp/chroot/
zcat ~/sitetmp/initrd* | sudo cpio -i -H newc -d  #unpack from gz


cp aria2/aria2c ~/sitetmp/chroot/bin/
mkdir -p ~/sitetmp/chroot/etc/ssl/certs/
cp aria2/ca-certificates.crt ~/sitetmp/chroot/etc/ssl/certs/ca-certificates.crt

cp 9990-mount-http.sh ~/sitetmp/chroot/usr/lib/live/boot/



find | sudo cpio -o -H newc | gzip -2 > ../initrd.img  #pack to gz
rm ~/sitetmp/chroot/* -rf



###assign var and debug for script

vmlinuz=$(/bin/ls ~/sitetmp/ |/bin/grep vmlinuz)
initrd=$(/bin/ls ~/sitetmp/ |/bin/grep initrd.img)

cinnamont=$(/bin/ls ~/sitetorrent/ |/bin/grep cinnamon)
gnomet=$(/bin/ls ~/sitetorrent/ |/bin/grep gnome)
kdet=$(/bin/ls ~/sitetorrent/ |/bin/grep kde)
lxdet=$(/bin/ls ~/sitetorrent/ |/bin/grep lxde)
lxqtt=$(/bin/ls ~/sitetorrent/ |/bin/grep lxqt)
matet=$(/bin/ls ~/sitetorrent/ |/bin/grep mate)
standardt=$(/bin/ls ~/sitetorrent/ |/bin/grep standard)
xfcet=$(/bin/ls ~/sitetorrent/ |/bin/grep xfce)

echo 'Check for ${vmlinuz}='"${vmlinuz}"' ${initrd}='"${initrd}"
echo "${cinnamont}"
echo "${gnomet}"
echo "${kdet}"
echo "${lxdet}"
echo "${lxqtt}"
echo "${matet}"
echo "${standardt}"
echo "${xfcet}"




cat << EOF > /p2p.ipxe
#!ipxe

goto p2p

:p2p
menu                                    P2P Boot Official Debian Buster

item --gap  -- Local Info
item --gap  -- IP:              \${ip}
item --gap  -- Netmask:         \${netmask}
item --gap  -- Mac Address:     \${mac}
item --gap  -- DHCP:            \${dhcp-server}
item --gap  -- Gateway:         \${gateway}
item --gap  -- DNS:             \${dns}
item --gap  -- next-server(proxy):      \${next-server}, \${proxydhcp/next-server}
item --gap  -- Chip:                    \${chip}
item --gap  -- Platform:        \${platform}
item --gap  -- Build Arch:      \${buildarch}
item --gap  -- Version:         \${version}
item --gap  -- https://hkkitlee.ddns.net:9000/
item --gap

item --gap  -- kernel: ${vmlinuz}
item --key 0    lxqt                    (0) Lxqt
item --key 1    gnome                   (1) Gnome
item --key 2    kde                     (2) Kde
item --key 3    lxde                    (3) Lxde
item --key 4    mate                    (4) Mate
item --key 5    standard                (5) Standard
item --key 6    xfce                    (6) Xfce
item --key 7    cinnamon                (7) Cinnamon
item --key 0x12 start                   (Ctrl-R) Return to First Menu

item --gap Keyboard shortcut (1-7,Ctrl-R)

choose --default gnome --timeout 20000 target && goto \${target}

:RPBL
kernel ~/sitetmp/${vmlinuz} initrd=${initrd} boot=live vga=normal components splash dhcp hooks=filesystem fetch=\${image}
initrd ~/sitetmp/${initrd}
boot || goto failed


:gnome
cpair --foreground 0 --background 9 0
console
set image https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/${gnomet}
goto RPBL || goto failed


:cinnamon
cpair --foreground 0 --background 9 0
console
set image https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/${cinnamont}
goto RPBL || goto failed

:kde
cpair --foreground 0 --background 9 0
console
set image https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/${kdet}
goto RPBL || goto failed

:lxde
cpair --foreground 0 --background 9 0
console
set image https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/${lxdet}
goto RPBL || goto failed

:lxqt
cpair --foreground 0 --background 9 0
console
set image https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/${lxqtt}
goto RPBL || goto failed

:mate
cpair --foreground 0 --background 9 0
console
set image https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/${matet}
goto RPBL || goto failed

:standard
cpair --foreground 0 --background 9 0
console
set image https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/${standardt}
goto RPBL || goto failed

:xfce
cpair --foreground 0 --background 9 0
console
set image https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/${xfcet}
goto RPBL || goto failed


EOF


umount ~/sitetorrent
umount ~/siteiso
