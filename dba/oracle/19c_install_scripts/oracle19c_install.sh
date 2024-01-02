#!/bin/bash
###############################################################################
## Oracle Database 19c Installation Script                                   ##
## Copyright 2023, Dustin K. Redmond                                         ## 
###############################################################################
## Details:                                                                  ##
##   Installs Oracle Database 19c on Oracle Linux.                           ##
##   This script creates operating system user oracle                        ##
##   as well as OS groups oinstall, dba, and oper.                           ##
###############################################################################

./assets/oracle19c_part1_root.sh
if ! [ $? -eq 0 ]; then
  echo "Unable to execute script part1. Exiting..."
  exit 99
fi

su -c './assets/oracle19c_part2_oracle.sh' oracle
# Commenting check on return code, as runInstaller sometimes
# returns non-zero values when it is successful.
# Shouldn't hurt to run the root scripts if non-zero is returned.
#if ! [ $? -eq 0 ]; then
#  echo "Unable to execute script part2. Exiting..."
#  exit 99
#fi

./assets/oracle19c_part3_root.sh
if ! [ $? -eq 0 ]; then
  echo "Unable to execute script part3. Exiting..."
  exit 99
fi

echo "Oracle Database 19c - Installed successfully."

read -p "Do you want to create a database automatically? (Y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  su -c './assets/oracle19c_part4_oracle.sh' oracle
  if [ $? -eq 0 ]; then
    echo "Database created successfully."
  else
    echo "Could not create database automatically."
	exit 99
  fi
fi