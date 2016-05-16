#!/bin/bash
#
# Script permettant l'installation de pack de scripts
#

destdir="~/tools"
tmpfile="~/script.zip"


echo " => Téléchargement des scripts"
wget https://github.com/geekariom/recal-script/archive/master.zip -O ${tmpfile} --show-progress --quiet
mkdir -p ${destdir}

echo " => Décompression"
unzip -o -d "${destdir}" -q ${tmpfile}

echo " => Suppression des fichiers temporaires"
rm ${tmpfile}

echo " => Fin de l'installation"
echo ""
read -p "Voulez-vous lancer le script maintenant ? (o/n)" ask
if [ $ask = 'o' ]; then
    bash ${destdir}/main.sh
fi

exit 0
