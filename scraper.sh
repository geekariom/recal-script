#!/bin/bash
#
# Scraper les images des jeux

source ~/geekariom/vars

# List of cpu : http://elinux.org/RPi_HardwareHistory
rpi0list="900092 900093"
rpi1list="Beta 0002 0003 0004 0005 0006 0007 0008 0009 000d 000e 000f 0010 0012 0013 0015"
rpi2list="a01041 a21041"
rpi3list="a02082 a22082"

# Detect Rpi
proc=$(cat /proc/cpuinfo | grep 'Revision' | awk '{print $3}' | sed 's/^1000//')
echo -n "=> Détection de la version du Raspberry : "

if [ "$proc" = "" ]; then
    echo "Introuvable ($(uname -m))"
    exit 2
elif [[ $rpi3list =~ $proc ]]; then
    echo "Raspberry PI 3 ($proc)"
    scraper=~/geekariom/tools/scrapper/scraper-rpi2
    nbworkers=4
elif [[ $rpi2list =~ $proc ]]; then
    echo "Raspberry PI 2 ($proc)"
    scraper=~/geekariom/tools/scrapper/scraper-rpi2
    nbworkers=2
elif [[ $rpi1list =~ $proc ]]; then
    echo "Raspberry PI 1 ($proc)"
    scraper=~/geekariom/tools/scrapper/scraper-rpi
    nbworkers=1
elif [[ $rpi0list =~ $proc ]]; then
    echo "Raspberry PI Zero ($proc)"
    scraper=~/geekariom/tools/scrapper/scraper-rpi2
    nbworkers=1
else
    echo "Introubable ($proc)"
    exit 2
fi

# Vérification de la cnx
echo -n "=> Vérification de la connexion Internet : "
if [ $(check_online) = "0" ]; then
    echo -e "Aucune\nUne connexion est requise pour scraper les jeux !"
    exit 3
else
    echo "OK"
fi

# Scrapper
cat <<EOF
#########################################################
######################## SCRAPER ########################
#########################################################
 Voici la liste des consoles supportées par le scraper :

* ATARI :
    1) Atari 2600       2) Atari 7800       3) Lynx
* NEOGEO :
    4) Neogeo           5) Neogeo pocket    6) Neogeo pocket color
* NINTENDO :
    7) NES              8) Super nintendo   9) N64          10) Virtual boy
    11) Gameboy         12) Gameboy advance                 13) Gameboy color
* SEGA :
    14) SG-1000         15) Master system   16) Sega CD     17) Sega 32X
    18) Gamegear        19) MegaDrive
* ARCADE :
    20) FBA             21) FBA Libretro    22) MAME
* NEC :
    23) PC Engine       24) SuperGrafx
* SONY :
    25) PlayStation
* Autres :
    26) Vectrex
-----------------------------------------------------------
Ctrl+C pour quitter
EOF

declare -a systemlist=('' 'atari2600' 'atari7800' 'lynx' 'neogeo' 'ngp' 'ngpc' 'nes' 'snes' 'n64' 'virtualboy' 'gb' 'gba' 'gbc' 'sg1000' 'mastersystem' 'segacd' 'sega32x' 'gamegear' 'megadrive' 'fba' 'fba_libretro' 'mame' 'pcengine' 'supergrafx' 'psx' 'vectrex')
list_mame="mame fba neogeo"
read -p "Taper le numéro (ou les numéros séparé par des espaces) des consoles à scraper :" consoles

echo -e "Pendant le scrap, l'écran de la recalbox va s'éteindre !\nIl se rallumera à la fin de l'opération"
read -p "Appuyer sur une touche pour lancer le scraper"
/etc/init.d/S31emulationstation stop
sleep 3
kill -9 $(ps aux|grep emulation | grep -v grep | awk '{ print $1 }')

for console in $consoles; do
    rom_name=${systemlist[$console]}
    echo "############## LANCEMENT DU SCRAPER POUR $rom_name ##############"
    opts=""
    if [[ $list_mame =~ $rom_name ]]; then
        opts='-mame -mame_img "m,t,s"'
    fi
    
    dir_rom=/recalbox/share/roms/$rom_name
    if [ -e $dir_rom/downloaded_images ]; then
        rm -r $dir_rom/downloaded_images
    fi
    
    ${scraper} \
            ${opts} \
            -no_thumb=true \
            -max_width=375 \
            -gdb_img="b,s,f" \
            -workers=$nbworkers \
            -img_workers=1 \
            -rom_dir="$dir_rom" \
            -output_file="$dir_rom/gamelist.xml" \
            -image_dir="$dir_rom/downloaded_images" \
            -image_path="./downloaded_images"
            
    if [ -e $dir_rom/downloaded_images ]; then
        nb=$(ls $dir_rom/downloaded_images | wc -l)
        echo "Fin du scraping de $rom_name : $nb image(s)"
    else
        echo "Fin du scraping de $rom_name : aucune image"
    fi
done

/etc/init.d/S31emulationstation start
