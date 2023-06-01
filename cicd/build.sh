#!/bin/bash -x
# BASE COMMUNE A TOUS LES PROJETS
cd $(dirname $0)/..
v=$(git describe --tags --long 2>/dev/null || echo "0.0.0")-${BUILD_NUMBER:-"XX"}
rm -rf cicd/TARGET && mkdir -p cicd/TARGET

##################################### A ADAPTER PAR PROJET #####################################
#BUILD
image=hupi/dataretriever:$v
docker build -t $image .

versionhtml=$image
##################################### FIN A ADAPTER PAR PROJET #####################################
## POTENTIELLEMENT A COMPLETER
#RIEN DE SPECIAL DANS TARGET, je MET LE MINIMUM pour la version
echo -n $v > cicd/TARGET/version # pas mettre de \n a la fin !
mkdir -p cicd/TARGET/reports/ && echo "<html><body><h1>Version: $versionhtml</h1></body></html>" > cicd/TARGET/reports/01-version.html

if [ "${BUILD_NUMBER}" != "" ] 
then
fold=/runner/jenkins/ARTEFACTS/$JOB_NAME/$v/
mkdir -p $fold/cicd/TARGET/
env >> $fold/ENV
rsync -av cicd/TARGET/ $fold/cicd/TARGET/
fi
