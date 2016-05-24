#!/bin/bash
#
# Script permettant l'installation de pack de scripts
# Run :  wget https://raw.githubusercontent.com/geekariom/recal-script/master/install.sh -O - | bash
#

destdir=/recalbox/share/tools/geekariom
tmpfile=~/script.zip
branch="master"

echo " => Téléchargement des scripts"
wget -O ${tmpfile} --show-progress --quiet https://github.com/geekariom/recal-script/archive/${branch}.zip

echo " => Création des dossiers"
if [ -e ${destdir} ]; then
    echo " => Suppression ancienne installation"
    rm -Rf ${destdir}
fi
mkdir -p ${destdir}

echo " => Décompression"
unzip -o -d "${destdir}" -q ${tmpfile}
mv ${destdir}/recal-script-${branch}/* ${destdir}

echo " => Suppression des fichiers temporaires"
rm ${tmpfile}
rm -Rf ${destdir}/recal-script-${branch}

echo -e " => Fin de l'installation\n"
read -p "Voulez-vous lancer le script maintenant ? (o/n) " start
if [ $start = 'o' ]; then
    bash ${destdir}/main.sh
fi

exit 0
