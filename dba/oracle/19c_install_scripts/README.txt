###############################################################################
## Oracle Database 19c - Automated Installation Script                       ##
## Created by: Dustin K. Redmond (dustin@dustinredmond.com)                  ##
## Purpose: Automate Oracle Database 19c installation on Oracle Linux 8.8    ##
###############################################################################
## Usage:                                                                    ##
## 1. Place a copy of the ZIP installation media in ./assets if not found,   ##
##    this script will prompt for full path to the ZIP file.                 ##
## 2. As user root, execute the oracle19c_install.sh                         ##
###############################################################################
## Steps carried out by the script:                                          ##
## 1. Prompt user for machine IP address                                     ##
## 2. Set values of ORACLE_BASE and ORACLE_HOME                              ##
## 3. Create OS user oracle                                                  ##
## 4. Create OS groups oinstall, dba, and oper                               ##
## 5. Change oracle's primary group to oinstall                              ##
## 6. Add oracle to groups dba and oper                                      ##
## 7. Create directory /u01/app/oracle/product/19.0.0/dbhome_1               ##
## 8. Change ownership of /u01 (and subdirectories) to oracle                ##
## 9. Add exception in firewalld for 1521/tcp (TNS)                          ##
## 10. Reload firewalld configuration                                        ##
## 11. Set SELinux to permissive mode                                        ##
## 12. Add export ORACLE_BASE command in /home/oracle/.bashrc                ##
## 13. Add export ORACLE_HOME command in /home/oracle/.bashrc                ##
## 14. Execute database 19c preinstallation scripts                          ##
## 15. Unzip oracle software at $ORACLE_HOME                                 ##
## 16. Change the ownership of the database software to user oracle          ##
## 17. Set parameter CV_ASSUME_DISTID in $ORACLE_HOME/cv/admin/cvu_config    ##
## 18. Execute $ORACLE_HOME/runInstaller in silent mode                      ##
## 19. As root, execute $ORACLE_BASE/../oraInventory/orainstRoot.sh          ##
## 20. As root, execute $ORACLE_HOME/root.sh                                 ##
## 21. As oracle, optionally, create container and pluggable DB using DBCA   ##
## 22. If a DB was created, add export ORACLE_SID to ~oracle/.bashrc         ##
###############################################################################
