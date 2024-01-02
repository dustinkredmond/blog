#!/bin/bash
###############################################################################
## Oracle Database 19c Installation Script                                   ##
## Copyright 2023, Dustin K. Redmond                                         ## 
###############################################################################
## Called from oracle19c_install.sh                                          ##
## Do not call this script directly!                                         ##
###############################################################################

if [[ $(whoami) -ne "root" ]]; then
  echo "You must be user root to execute this script."
  exit 99
fi

echo "This script installs Oracle Database 19c on an Oracle Linux machine."
echo "It assumes that operating system user oracle does not yet exist, but"
echo "its execution will still succeed if it does."
echo ""
echo "You will be prompted for one input:"
echo "  1. The IP address of this machine"
echo ""
read -p "Continue with installation? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

echo "Starting installation of Oracle Database 19c on $(hostname) at $(date)"

# Set ORACLE_BASE and ORACLE_HOME to a suitable OFA compliant location
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1

read -p "Enter IP address of machine $(hostname): " OEL_IP
ORACLE_SOFTWARE="$(pwd)/assets/LINUX.X64_193000_db_home.zip"

if [[ -z "$OEL_IP" ]]; then
  echo "Cannot continue without machine's IP address. Exiting..."
  exit 99
fi

if ! [[ -f "$ORACLE_SOFTWARE" ]]; then
  echo "Could not find $ORACLE_SOFTWARE"
  read -p "Enter full path to Oracle installation ZIP file: " ORACLE_SOFTWARE
fi

if ! [[ -f "$ORACLE_SOFTWARE" ]]; then
  echo "Could not find Oracle database ZIP installation media. Exiting..."
  exit 99
fi

useradd oracle

groupadd oinstall
groupadd dba
groupadd oper

if ! [ $(getent group oinstall) ]; then
  echo "Could not add OS group oinstall. Exiting..."
  exit 99
fi

if ! [ $(getent group dba) ]; then
  echo "Could not add OS group dba. Exiting..."
  exit 99
fi

if ! [ $(getent group oper) ]; then
  echo "Could not add OS group oper. Exiting..."
  exit 99
fi


usermod -g oinstall oracle
usermod -a -G dba oracle
usermod -a -G oper oracle

mkdir -p $ORACLE_HOME

if ! [[ -d "$ORACLE_HOME" ]]; then
  echo "Could not add directory $ORACLE_HOME"
  exit 99
fi

chown -R oracle:oinstall $ORACLE_HOME
chown -R oracle:oinstall /u01

echo "$OEL_IP $(hostname)" >> /etc/hosts

firewall-cmd --permanent --zone=public --add-port=1521/tcp
if [ $? -eq 0 ]; then
  firewall-cmd --reload
else
  echo "Could not add exception to firewalld for 1521/tcp (TNS)."
  echo "You may be unable to connect to Oracle from a remote machine."
fi

cp /etc/selinux/config /etc/selinux/config.bak
cat /etc/selinux/config.bak | sed s/"SELINUX=enforcing"/"SELINUX=permissive"/g > /etc/selinux/config
setenforce Permissive
if ! [ $? -eq 0 ]; then
  echo "Could not set SELinux to permissive mode. Installation will fail. Exiting..."
  exit 99
fi

echo "export ORACLE_BASE=$ORACLE_BASE" >> ~oracle/.bashrc
echo "export ORACLE_HOME=$ORACLE_HOME" >> ~oracle/.bashrc
echo "export PATH=$PATH:$ORACLE_HOME/bin" >> ~oracle/.bashrc

yum -y install oracle-database-preinstall-19c
if ! [ $? -eq 0 ]; then
  echo "Could not install oracle-database-preinstall-19c preinstallation script. Exiting..."
  exit 99
fi

cd $ORACLE_HOME
unzip -q $ORACLE_SOFTWARE
chown -R oracle:oinstall $ORACLE_HOME
echo "CV_ASSUME_DISTID=OEL5" >> $ORACLE_HOME/cv/admin/cvu_config
