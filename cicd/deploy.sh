#!/bin/bash -x
# BASE COMMUNE A TOUS LES PROJETS
cd $(dirname $0)/..

if [ "${BUILD_NUMBER}" != ""  ] 
then
fold=$(echo /runner/jenkins/ARTEFACTS/$JOB_NAME/$2/|sed -e 's#DEPLOY_##g')
[ -e $fold ] && rsync -av  $fold/cicd/TARGET/ cicd/TARGET/
fi

##################################### A ADAPTER PAR PROJET #####################################
#$1 => L environnment
#$2 => la version
set -e
# NOM DE L IMAGE en fonction de $1 et $2 :
image=hupi/dataretriever:$2



# DEFINIR UNE FONCTION PAR ENV

function deploy_PKG_ONLY() {
	docker push $image

}


function deploy_PROD() {
	deploy_PKG_ONLY
	server=XXXXXXX
	ssh $server  docker image prune  -a -f ;
	ssh $server  "docker service update dataretriever_dataretriever --image $image;"
}



function deploy_TEST() {
	deploy_PKG_ONLY
	server=XXXXX
	ssh $server  docker image prune  -a -f ;
	ssh $server  "docker service update dataretriever_dataretriever --image $image;"
}


##################################### FIN A ADAPTER PAR PROJET #####################################

#COMMUN A TOUS LES PROJETS

# les ENV (cf fonction au dessus)
if [ "$1" = "" ] 
then
echo "PAS DE ENV"
exit 1
fi

c=$(grep -c "^$1$" cicd/ENV)

if [ $c -eq 0 ]
then
echo "ENV $1 NOT FOUND"
echo "List of Valid ENV : "
cat cicd/ENV
exit 1
fi
deploy_$1

set +e
