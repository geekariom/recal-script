#!/bin/bash
#
# Script permettant l'installation de pack de scripts
# Run :  wget https://raw.githubusercontent.com/geekariom/recal-script/master/install.sh -O - | bash
#

destdir=~/geekariom
tmpfile=~/script.zip

echo " => Téléchargement des scripts"
wget -O ${tmpfile} --show-progress --quiet https://github.com/geekariom/recal-script/archive/master.zip

echo " => Création des dossiers"
if [ -e ${destdir} ]; then
    echo " => Suppression ancienne installation"
    rm -Rf ${destdir}
fi
mkdir -p ${destdir}

echo " => Décompression"
unzip -o -d "${destdir}" -q ${tmpfile}
mv ${destdir}/recal-script-master/* ${destdir}/

echo " => Suppression des fichiers temporaires"
rm ${tmpfile}
rm -Rf ${destdir}/recal-script-master

echo -e " => Fin de l'installation\n"
echo "Voulez-vous lancer le script maintenant ? (o/n) " 
read start
if [ $start = 'o' ]; then
    /bin/bash ${destdir}/main.sh;
fi

exit 0
