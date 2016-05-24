#!/bin/bash
#
# Activer ou désactiver le menu noobs au démarrage
#

partition=/dev/mmcblk0p1

echo " => Désactiver le menu NOOBS permet de gagner quelques secondes lors du démarrage de la Recalbox"

if [ ! -f $partition ]; then
    echo "Partition $partition introuvable"
    exit 1
fi

echo " => Montage de la partition $partition sur /mnt"
mount $partition /mnt
need_reboot=0

disable=$(test -e /mnt/autoboot.txt && echo "1" || echo "0")
if [ $disable -eq 1 ]; then
    echo "Le menu NOOBS est désactivé !"
    read -p "Faut-il le réactiver ? (o/n)" ask
    if [ $ask = "o" ]; then
        rm -f /mnt/autoboot.txt
        need_reboot=1
    fi
else
    echo "Le menu NOOBS est activé !"
    read -p "Faut-il le désactiver ? (o/n)" ask
    if [ $ask = "o"]; then
        echo "boot_partition=6" > /mnt/autoboot.txt
        need_reboot=1
    fi
fi

echo " => Démontage de la partition $partition"
umount /mnt

if [ $need_reboot -eq 1 ]; then
    ask_reboot
fi
exit 0

