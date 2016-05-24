#!/bin/bash
#
# Script général
#

show_menu() {
    clear
    echo "##############################################"
    echo "#################### MENU ####################"
    echo "##############################################"
    echo ""
    echo "0) Quitter"
    echo "1) Augmenter/Réduire tension des ports USB"
    echo "2) Activer/Désactiver le menu NOOBS"
    echo "3) Mise à jour du script"
    echo "8) Redémarrer la recalbox"
    echo "9) Éteindre la recalbox"
    echo ""
    read -p "Choix [0-9] ?" choix
    
    case $choix in
        # USB Power
        1)
            bash ~/geekariom/usb-power.sh
            ;;
            
        # Noobs screen
        2)
            bash ~/geekariom/noobs.sh
            ;;
        
        # Update    
        3)
            bash ~/geekariom/install.sh
            ;;
        
            
        # Restart
        8)
            shutdown -r now
            ;;
            
        # Halt
        9)
            shutdown -h now
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
