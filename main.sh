#!/bin/bash
#
# Script général
#

show_menu() {
    echo "##############################################"
    echo "#################### MENU ####################"
    echo "##############################################"
    echo ""
    echo "0) Quitter"
    echo "1) Augmenter/Réduire tension des ports USB"
    echo "2) Activer/Désactiver le menu NOOBS"
    echo ""
    read -p "Choix [0-2] ?" choix
    case $choix in
        # USB Power
        1)
            bash ~/geekariom/usb-power.sh
            ;;
            
        # Noobs screen
        2)
            bash ~/geekariom/noobs.sh
            ;;
            
        # Quitter
        0)
            exit 0
            ;;
            
        # Mauvais choix
        *)
            echo "Choix incorrect ($choix) !"
            exit 1
            ;;
    esac
}

show_menu
