#!/bin/bash
# File Name: cert_check.sh
# 
# Script to check website certificate expiry date
# and e-mail warning message to sysadmin. Note that
# this script should really never send any e-mails, as
# the certbot utility should automatically renew the cert,
# but this is a safeguard in case it fails to do so... 

WARN_DAYS=10
CRITICAL_DAYS=3
SENDER="sender@example.com"
RECIPIENT="recip@example.com"
SMS_RECIPIENT="5551234567@vtext.com"

# Execute certbot certificates command, redirect output to log file
sudo certbot certificates > ~/logs/certbot_certs_expiry.log

# Parse log file to find days certificate remains valid
tail -n 4 ~/logs/certbot_certs_expiry.log | head -n 1 | awk '{$1=$1;print}' > ~/logs/certbot_certs_expiry.log.tmp
mv ~/logs/certbot_certs_expiry.log.tmp ~/logs/certbot_certs_expiry.log 
DAYS_LEFT=$(cut -d " " -f 6 < ~/logs/certbot_certs_expiry.log)

# If days remaining before cert expiry <= WARN_DAYS, send e-mail
if [[ $DAYS_LEFT -le $WARN_DAYS ]]; then
  echo "SSL expires in $WARN_DAYS or less days" | mail -r $SENDER -s "SSL - $(hostname)" $RECIPIENT 

  # If days remaining before cert expiry <= CRITICAL_DAYS, send SMS message
  if [[ $DAYS_LEFT -le $CRITICAL_DAYS ]]; then
    echo|mail -r $SENDER -s "SSL cert expiring soon $(hostname)" $SMS_RECIPIENT
  fi
fi