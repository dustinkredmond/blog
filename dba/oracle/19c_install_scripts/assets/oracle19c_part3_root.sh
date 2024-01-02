#!/bin/bash
###############################################################################
## Oracle Database 19c Installation Script                                   ##
## Copyright 2023, Dustin K. Redmond                                         ## 
###############################################################################
## Called from oracle19c_install.sh                                          ##
## Do not call this script directly!                                         ##
###############################################################################

if [[ $(whoami) -ne "root" ]]; then
  echo "You must be root to execute this script"
  exit 99
fi

. ~oracle/.bashrc

cd $ORACLE_BASE/../oraInventory
./orainstRoot.sh

cd $ORACLE_HOME
./root.sh

echo "Oracle 19c Installation complete at $(date)"
