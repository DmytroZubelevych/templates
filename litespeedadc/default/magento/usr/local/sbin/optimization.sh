#!/bin/bash

LSLB_CONF="/var/www/conf/lslbd_config.xml"
VH_CONF="/var/www/conf/jelastic.xml"
ED_CMD="ed --inplace"

cp -f ${LSLB_CONF} ${LSLB_CONF}.backup.$(date +%d-%m-%Y.%H:%M:%S.%N) || exit 1

#Enable LiteMage
/usr/bin/xmlstarlet ${ED_CMD} -u "virtualHostConfig/cache/storage/litemage" -v "1" "${VH_CONF}" 2>/dev/null;

#Enable  cachePolicy
/usr/bin/xmlstarlet ${ED_CMD} -d "virtualHostConfig/cache/cachePolicy" "${VH_CONF}" 2>/dev/null;
/usr/bin/xmlstarlet ${ED_CMD} -s "virtualHostConfig/cache"  -t elem -n "cachePolicy" "${VH_CONF}" 2>/dev/null;
/usr/bin/xmlstarlet ${ED_CMD} -s "virtualHostConfig/cache/cachePolicy"  -t elem -n "checkPublicCache" -v "1" "${VH_CONF}" 2>/dev/null;
/usr/bin/xmlstarlet ${ED_CMD} -s "virtualHostConfig/cache/cachePolicy"  -t elem -n "checkPrivateCache" -v "1" "${VH_CONF}" 2>/dev/null;
/usr/bin/xmlstarlet ${ED_CMD} -s "virtualHostConfig/cache/cachePolicy"  -t elem -n "cacheStaticFile" -v "15" "${VH_CONF}" 2>/dev/null;

# Reload service
sudo jem service restart
