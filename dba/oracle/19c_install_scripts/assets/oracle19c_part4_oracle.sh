#!/bin/bash
###############################################################################
## Oracle Database 19c Installation Script                                   ##
## Copyright 2023, Dustin K. Redmond                                         ## 
###############################################################################
## Called from oracle19c_install.sh                                          ##
## Do not call this script directly!                                         ##
###############################################################################

. ~oracle/.bashrc

read -p "Enter name for the container database [ORCL]: " script_cdb_name
read -p "Enter name for the pluggable database [PDB1]: " script_pdb_name

if [[ -z "$script_cdb_name" ]]; then
  script_cdb_name="ORCL"
fi

if [[ -z "$script_pdb_name" ]]; then
  script_pdb_name="PDB1"
fi

echo "export ORACLE_SID=$script_cdb_name" >> ~oracle/.bashrc

RSP_FILE=/home/oracle/dbca.rsp

echo "responseFileVersion=/oracle/assistants/rspfmt_dbca_response_schema_v12.2.0" > $RSP_FILE
echo "gdbName=$script_cdb_name" >> $RSP_FILE
echo "sid=$script_cdb_name" >> $RSP_FILE
echo "databaseConfigType=SI" >> $RSP_FILE
echo "createAsContainerDatabase=true" >> $RSP_FILE
echo "numberOfPDBs=1" >> $RSP_FILE
echo "pdbName=$script_pdb_name" >> $RSP_FILE
echo "useLocalUndoForPDBs=true" >> $RSP_FILE
echo "templateName=/u01/app/oracle/product/19.0.0/dbhome_1/assistants/dbca/templates/General_Purpose.dbc" >> $RSP_FILE
echo "datafileJarLocation={ORACLE_HOME}/assistants/dbca/templates/" >> $RSP_FILE
echo "datafileDestination={ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/" >> $RSP_FILE
echo "recoveryAreaDestination={ORACLE_BASE}/fast_recovery_area/{DB_UNIQUE_NAME}" >> $RSP_FILE
echo "storageType=FS" >> $RSP_FILE
echo "characterSet=AL32UTF8" >> $RSP_FILE
echo "variables=ORACLE_BASE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1,DB_UNIQUE_NAME=$script_cdb_name,ORACLE_BASE=/u01/app/oracle,PDB_NAME=,DB_NAME=$script_cdb_name,ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1,SID=$script_cdb_name" >> $RSP_FILE
echo "initParams=undo_tablespace=UNDOTBS1,db_block_size=8KB,dispatchers=(PROTOCOL=TCP) (SERVICE={SID}XDB),diagnostic_dest={ORACLE_BASE},remote_login_passwordfile=EXCLUSIVE,db_create_file_dest={ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/,audit_file_dest={ORACLE_BASE}/admin/{DB_UNIQUE_NAME}/adump,processes=320,memory_target=1444MB,db_recovery_file_dest_size=12732MB,open_cursors=300,compatible=19.0.0,db_name=ORCL,db_recovery_file_dest={ORACLE_BASE}/fast_recovery_area/{DB_UNIQUE_NAME},audit_trail=db" >> $RSP_FILE
echo "memoryPercentage=40" >> $RSP_FILE
echo "databaseType=MULTIPURPOSE" >> $RSP_FILE
echo "automaticMemoryManagement=true" >> $RSP_FILE

$ORACLE_HOME/bin/dbca -silent -createDatabase -responseFile $RSP_FILE