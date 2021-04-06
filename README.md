# RPBL Ryanboot P2P/BitTorrent Boot Linux
### Ryanboot P2P/BitTorrent Boot Linux by aria2c

## This is a PART of Ryanboot:[Github](https://github.com/hkkitlee/Ryanboot) [Gitee](https://gitee.com/hkkitlee/Ryanboot)

A modified initrd.img from "Debian Buster Live" for support the BT/P2P boot, should keep all parameter/function from official.
i tried my best for the simplest coding and keep it clean.
Tested on kvm.

改造一個initrd.img經網絡啟動pxe，並以p2p/bittorrent協議加載。官方功能/參數沒變。
盡最大程度簡化代碼。已在kvm測試。


## Howto:
Ryanboot:[Github](https://github.com/hkkitlee/Ryanboot) [Gitee](https://gitee.com/hkkitlee/Ryanboot)

or
```
#!ipxe
dhcp
goto start
:start
chain --autofree https://github.com/hkkitlee/Ryanboot/raw/main/chain.ipxe || chain --autofree https://gitee.com/hkkitlee/Ryanboot/raw/main/chain.ipxe || chain --autofree http://hkkitlee.ddns.net:8999/chain.ipxe || goto start
```

or
```
#!ipxe
dhcp
goto start
:start
chain --autofree https://github.com/hkkitlee/Ryanboot-P2PBitTorrent-Boot-Linux/raw/master/RPBL.ipxe || chain --autofree https://gitee.com/hkkitlee/Ryanboot-P2PBitTorrent-Boot-Linux/raw/master/RPBL.ipxe || goto start
```


### Please see the uploaded 9990-mount-http.sh, i did :
* 1.add remarked script for check the /proc/cmdline if fetch="*.iso.torrent" and use aria2c for P2P download iso.增加核心參數註解，當偵測到fetch後是*.iso.torrent時使用aria2c使用p2p下載iso。
* 2.put the aria2c to /bin.將aria2c放入bin。
* 3.finally change the ${url} ${extension} back to "iso" for below mounting.最後將${url}${extension}變量改回iso繼續官方腳本掛載處理。

### btmod.sh 
* included howto mod the initrd &  create ipxe.script.修改細節、編寫ipxe腳本在btmod.sh


### Or repack initrd after modifed as per btmod.sh.重新修改後打包成一個initrd.img亦可，詳情可查看btmod.sh

### Restriction Note, since use the official mount iso function:限制：
* 1.The iso name seed as XXX.iso, so the torrent must be XXX.iso.torrent
* 2.P2P should only support iso file now(no squashfs now).
* 3.WIRED Network is needed like from pxe.
