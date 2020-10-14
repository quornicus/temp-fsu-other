#!/usr/bin/env bash

function images_up {
    [[ ${1} ]] && local SET_BG="-d"
    docker run -p 8080:8080 \
        --name image-services \
        --env-file /home/ubuntu/temp-fsu-other/all-envs.env \
        ${SET_BG} fsu-imageservices:1.0
}

function apache_up {
    [[ ${1} ]] && local SET_BG="-d"
    docker run -p 80:80 \
        --name apache \
        --mount type=bind,src=/home/ubuntu/data/apache/html,dst=/var/www/html \
        --mount type=bind,src=/home/ubuntu/data/apache/settings.php,dst=/var/www/html/sites/default/settings.php \
        --env-file /home/ubuntu/temp-fsu-other/all-envs.env \
        ${SET_BG} fsu-apache:1.0
}

function fedora_up {
    [[ ${1} ]] && local SET_BG="-d"
    docker run -p 8080:8080 \
        --name fedora \
        --mount type=bind,src=/home/ubuntu/data/fedora/datastreamStore,dst=/usr/local/fedora/data/datastreamStore \
        --mount type=bind,src=/home/ubuntu/data/fedora/objectStore,dst=/usr/local/fedora/data/objectStore \
        --mount type=bind,src=/home/ubuntu/data/fedora/akubra-llstore.xml,dst=/usr/local/fedora/server/config/spring/akubra-llstore.xml \
        --mount type=bind,src=/home/ubuntu/data/fedora/gsearch/RELS-EXT_to_solr.xslt,dst=/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/RELS-EXT_to_solr.xslt \
        --mount type=bind,src=/home/ubuntu/data/fedora/gsearch/foxmlToSolr.xslt,dst=/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt \
        --env-file /home/ubuntu/temp-fsu-other/all-envs.env \
        ${SET_BG} fsu-fedora:1.0
}

function blaze_up {
    [[ ${1} ]] && local SET_BG="-d"
    docker run -p 8080:8080 \
        --name blaze \
        --mount type=bind,src=/home/ubuntu/data/bigdata,dst=/var/bigdata \
        --env-file /home/ubuntu/temp-fsu-other/all-envs.env \
        ${SET_BG} islandoracollabgroup/isle-blazegraph:1.5.1
}

function mysql_up {
    [[ ${1} ]] && local SET_BG="-d"
    docker run -p 3306:3306 \
        --name mysql \
        --mount type=bind,src=/home/ubuntu/data/mysql/ISLE.cnf,dst=/etc/mysql/mysql.conf.d/ISLE.cnf \
        --mount type=bind,src=/home/ubuntu/data/mysql/data,dst=/var/lib/mysql \
        --env-file /home/ubuntu/envs.env \
        ${SET_BG} islandoracollabgroup/isle-mysql:1.5.1
}

function solr_up {
    [[ ${1} ]] && local SET_BG="-d"
    docker run -p 8080:8080 \
        --name solr \
        --mount type=bind,src=/home/ubuntu/data/solr/data,dst=/usr/local/solr/collection1/data \
        --env-file /home/ubuntu/temp-fsu-other/all-envs.env \
        ${SET_BG} islandoracollabgroup/isle-solr:1.5.1
}

case "${1}" in
    apache)
        apache_up ${2}
        ;;
    fedora)
        fedora_up ${2}
        ;;
    mysql)
        mysql_up ${2}
        ;;
    solr)
        solr_up ${2}
        ;;
    blazegraph)
        blaze_up ${2}
        ;;
    image-services)
        images_up ${2}
        ;;
esac
