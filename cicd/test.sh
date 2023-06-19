#!/bin/bash -x
# BASE COMMUNE A TOUS LES PROJETS
cd $(dirname $0)/..
v=$(git describe --tags --long 2>/dev/null || echo "0.0.0")-${BUILD_NUMBER:-"XX"}
docker_image=hupi/dataretriever:$v

#TEST UNITAIRE (resultat attendues dans ./cicd/TEST/*xml )

#SONAR


#SECU
[ ! -e /tmp/ansi2html.sh ] && wget https://raw.githubusercontent.com/pixelb/scripts/master/scripts/ansi2html.sh -O /tmp/ansi2html.sh && chmod a+x /tmp/ansi2html.sh
docker run --rm  -v /var/run/docker.sock:/var/run/docker.sock  goodwithtech/dockle $dockle_option  $docker_image | bash /tmp/ansi2html.sh >  cicd/TARGET/reports/03-DOCKLE.html
docker run --rm  -v $PWD:/myapp -v /var/run/docker.sock:/var/run/docker.sock  aquasec/trivy image  $docker_image | bash /tmp/ansi2html.sh >  cicd/TARGET/reports/04-TRIVY.html

