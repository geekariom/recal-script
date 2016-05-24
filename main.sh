#!/bin/bash
#
# Script général
#

source ./vars

show_menu() {
    clear
    echo "##############################################"
    echo "#################### MENU ####################"
    echo "##############################################"
    echo ""
    echo "0) Quitter"
    echo "1) Augmenter/Réduire tension des ports USB"
    echo "2) Activer/Désactiver le menu NOOBS"
    echo ""
    read -p "Choix [0-2] ?" choix
    clear
    
    case $choix in
        # USB Power
        1)
            bash ${SCRIPTDIR}/usb-power.sh
            ;;
            
        # Noobs screen
        2)
            bash ${SCRIPTDIR}/noobs.sh
            ;;
            
        # Quitter
        0)
            exit 0
            ;;
            
        # Mauvais choix
        *)
            echo "Choix incorrect !"
            exit 1
            ;;
    esac
}

show_menu
