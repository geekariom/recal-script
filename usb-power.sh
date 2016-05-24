#!/bin/bash
#
# Optimiser la tension du Rpi
#

source ~/geekariom/vars

if [ ! -f /boot/config.txt ]; then
    echo " /!\ Fichier de configuration introuvable !"
    exit 1
fi

enabled=$(cat /boot/config.txt | grep "max_usb_current=1" | wc -l)
echo "### Augmenter la tension des ports USB ###"

if [ $enabled = "1" ]; then
    read -p " => La tension est déjà augmenté ! Faut-il la réduire ? (o/n)" ask
else
    read -p " => Confirmation de l'augmentation de la tension ? (o/n)" ask
fi

if [ $ask = "o" ]; then
    mount_boot
    
    if [ $enabled = "1" ]; then
        sed -i '/max_usb_current/d' /boot/config.txt
    else
        echo "max_usb_current=1" >> /boot/config.txt
    fi
    
    umount_boot
    ask_reboot
else
    echo " => Aucune modification\n"
fi

exit 0
