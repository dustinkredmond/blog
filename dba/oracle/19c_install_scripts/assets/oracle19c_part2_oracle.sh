#!/bin/bash
###############################################################################
## Oracle Database 19c Installation Script                                   ##
## Copyright 2023, Dustin K. Redmond                                         ## 
###############################################################################
## Called from oracle19c_install.sh                                          ##
## Do not call this script directly!                                         ##
###############################################################################

if [[ $(whoami) -ne "oracle" ]]; then
  echo "You must be oracle to execute this script."
  exit 99
fi

. ~oracle/.bashrc
cd $ORACLE_HOME

./runInstaller -ignorePrereq -waitforcompletion -silent                        \
    -responseFile ${ORACLE_HOME}/install/response/db_install.rsp               \
    oracle.install.option=INSTALL_DB_SWONLY                                    \
    ORACLE_HOSTNAME="$(hostname)"                                              \
    UNIX_GROUP_NAME=oinstall                                                   \
    INVENTORY_LOCATION="$ORACLE_BASE/../oraInventory"                          \
    SELECTED_LANGUAGES=en,en_US                                                \
    ORACLE_HOME=${ORACLE_HOME}                                                 \
    ORACLE_BASE=${ORACLE_BASE}                                                 \
    oracle.install.db.InstallEdition=EE                                        \
    oracle.install.db.OSDBA_GROUP=dba                                          \
    oracle.install.db.OSBACKUPDBA_GROUP=dba                                    \
    oracle.install.db.OSDGDBA_GROUP=dba                                        \
    oracle.install.db.OSKMDBA_GROUP=dba                                        \
    oracle.install.db.OSRACDBA_GROUP=dba                                       \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false                                 \
    DECLINE_SECURITY_UPDATES=true

