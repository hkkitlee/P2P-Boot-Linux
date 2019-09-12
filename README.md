# Ryan P2P-Boot-Linux
Ryan P2P Boot Linux by aria2c

Hello everybody

i am just a newbie, this is my first time to use github. Actually i am not know how to use github....Feel Sorry.

Would let you know i modified the initrd.img from "Debian Buster Live Gnome" for support the P2P boot, should keep all parameter/function from official.
i try my best for the smallest coding and keep it clean.
Tested on kvm.

Please see the uploaded 9990-mount-http.sh, i did :
1.add remarked script for check the /proc/cmdline if fetch="*.iso.torrent" and use aria2c for P2P download iso.
2.put the aria2c to /bin.
3.finally change the ${url} ${extension} back to "iso" for below mounting.

How to use (ipxe diskless example):

:rpbl
echo Debian Live booting...
kernel ${base}pub/debian/live/vmlinuz-4.19.0-6-amd64 initrd=initrd.img-4.19.0-6-amd64 boot=live vga=normal components splash hostname=DebianLive username=user ip=dhcp hooks=filesystem fetch=https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/debian-live-10.1.0-amd64-gnome.iso.torrent
initrd ${base}pub/debian/live/initrd.img-4.19.0-6-amd64
boot || goto failed


Restriction Note, since use the official mount iso function:
1.The iso name seed as XXX.iso, so the torrent must be XXX.iso.torrent
2.P2P should only support iso file now.
