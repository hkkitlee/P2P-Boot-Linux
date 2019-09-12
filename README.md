# P2P-Boot-Linux
P2P Boot Linux by aria2c
Hello everybody

i am just a newbie, this is my first time to use github.Actually i am not know how to use github....Feel Sorry.

Would let you know i just modified the initrd.img from Debian Buster Live Gnome for support the P2P boot, keep all parameter
from official.
i try my best to the smallest coding and keep it clean.

Please see the uploaded 9990-mount-http.sh, i just :
1.add remarked script for check the /proc/cmdline if fetch="*.iso.torrent" and use aria2c for P2P download iso.
2.put the aria2c to /bin.
3.finally change the ${url} ${extension} back to "iso" for below mounting.

Restriction Note, since use the official mount iso function:
1.The iso name seed as XXX.iso, so the torrent must be XXX.iso.torrent
2.Should only iso file support now.
