#!/bin/sh
###https://github.com/hkkitlee/P2P-Boot-Linux.git
###modify initrd.img base on Debian Buster Live Gnome by hkkitlee for support P2P (iso.torrent) boot.
###Date on 2019/Sep/12.
###All offical function should keep and tested iso.torrent.
###Three # for notes.

#set -e

do_httpmount ()
{
	rc=1

	for webfile in HTTPFS FTPFS FETCH
	do
		local url extension dest
		url="$(eval echo \"\$\{${webfile}\}\")"
		extension="$(echo "${url}" | sed 's/\(.*\)\.\(.*\)/\2/')"

		if [ -n "$url" ]
		then
			case "${extension}" in
				iso|squashfs|tgz|tar|torrent)														###Add *.torrent to support below function
					if [ "${extension}" = "iso" ] || [ "${extension}" = "torrent" ]									###Make the iso.torrent perparation like iso
					then
						mkdir -p "${alt_mountpoint}"
						dest="${alt_mountpoint}"
					else
						dest="${mountpoint}/${LIVE_MEDIA_PATH}"
						mount -t ramfs ram "${mountpoint}"
						mkdir -p "${dest}"
					fi
					case "${url}" in
						*:///*) url="${url%%:///*}://${ROOTSERVER}/${url##*:///}" ;;
					esac
					if [ "${webfile}" = "FETCH" ]
					then
						case "$url" in
							tftp*)
								ip="$(dirname $url | sed -e 's|tftp://||g' -e 's|/.*$||g')"
								rfile="$(echo $url | sed -e "s|tftp://$ip||g")"
								lfile="$(basename $url)"
								log_begin_msg "Trying tftp -g -b 65464 -r $rfile -l ${dest}/$lfile $ip"
								tftp -g -b 65464 -r $rfile -l ${dest}/$lfile $ip
							;;

							*)
								if [ "${extension}" = "torrent" ]									###Add IF for torrent and use aria2c to download the iso file by p2p.
								then
									log_begin_msg "Ryan's P2P Boot Linux Start as ${url} to ${dest}/$(basename ${url})"		###Notice the user now use aria2c.
									aria2c --follow-torrent=mem "${url}" -d "${dest}/" --seed-time=0 --enable-dht=false		###The torrent come from cmdline (loader).
									url="$(echo $url | sed 's/ *\.torrent.*$//g')"							###Would like to merge the job like iso below, change $url(from cmdline) from iso.torrent to iso. 
									extension="iso"											###Also merge to iso, change the $extension to iso.
								else
									log_begin_msg "Trying wget ${url} -O ${dest}/$(basename ${url})"
									wget "${url}" -O "${dest}/$(basename ${url})"
								fi
								;;
						esac
					else
						log_begin_msg "Trying to mount ${url} on ${dest}/$(basename ${url})"
						if [ "${webfile}" = "FTPFS" ]
						then
							FUSE_MOUNT="curlftpfs"
							url="$(dirname ${url})"
						else
							FUSE_MOUNT="httpfs"
						fi

						modprobe fuse
						$FUSE_MOUNT "${url}" "${dest}"
						ROOT_PID="$(minips h -C "$FUSE_MOUNT" | { read x y ; echo "$x" ; } )"
					fi
					[ ${?} -eq 0 ] && rc=0
					[ "${extension}" = "tgz" ] && live_dest="ram"
					if [ "${extension}" = "iso" ]
					then
						isoloop=$(setup_loop "${dest}/$(basename "${url}")" "loop" "/sys/block/loop*" "" '')
						mount -t iso9660 "${isoloop}" "${mountpoint}"
						rc=${?}
					fi
					break
					;;

				*)
					log_begin_msg "Unrecognized archive extension for ${url}"
					;;
			esac
		fi
	done

	if [ ${rc} != 0 ]
	then
		if [ -d "${alt_mountpoint}" ]
		then
			umount "${alt_mountpoint}"
			rmdir "${alt_mountpoint}"
		fi
		umount "${mountpoint}"
	elif [ "${webfile}"  != "FETCH" ] ; then
		NETBOOT="${webfile}"
		export NETBOOT
	fi

	return ${rc}
}
