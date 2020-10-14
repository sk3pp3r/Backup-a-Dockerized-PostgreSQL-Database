#!/bin/bash

################################################################################################################################
# This script backup a dockerized PostgreSQL database
# Backup target path - windows share : //server/share/
# keep backup history: 30 days
#
# script editor: Haim Cohen 
# Linkedin: https://www.linkedin.com/in/haimc/
# Github: https://sk3pp3r.github.io/
# version:       1.3, Oct 13, 2020
################################################################################################################################

# You need to replace each {ITEM} with relevant information
# This script test on RHEL 8 with Docker version 19.03.13
# to ad a daily cron job do the following steps:
#       sudo crontab -e
#       @daily /bin/bash {script location}backup_postgres.sh >/dev/null 2>&1




mail_ok () {
  cat >/tmp/mail_ok.log <<EOF
This is an automated message. Please do not reply.

The backup a dockerized PostgreSQL database completed without errors.

EOF
echo dump file info: $(ls /mnt -lh | tail -1) >> /tmp/mail_ok.log
echo backup runs as user: $(whoami) >> /tmp/mail_ok.log
echo hostname: $(hostname) >> /tmp/mail_ok.log

echo `date +%d-%m-%Y` `date +%H:%M`  >> /tmp/mail_ok.log
mailx -S smtp={SMTP_SERVER} -s "Backup dockerized PostgreSQL DB Completed" -v {user@domain.com}</tmp/mail_ok.log >/dev/null 2>&1
}


mail_x () {
  cat >/tmp/mail_x.log <<EOF
This is an automated message. Please do not reply.

The backup a dockerized PostgreSQL database failed.
Backup runs from Cronjob.

EOF
echo backup runs as user $(whoami) >> /tmp/mail_x.log
echo hostname: $(hostname) >> /tmp/mail_x.log
echo `date +%d-%m-%Y` `date +%H:%M` >> /tmp/mail_x.log
echo script name: $0 >> /tmp/mail_x.log

mailx -S smtp={SMTP_SERVER} -s "Backup dockerized PostgreSQL DB failed" -v {use@domain.com} </tmp/mail_x.log >/dev/null 2>&1
}


mount_point () {
  mount -t cifs | grep '//server/share' >/dev/null 2>&1
  ret=$?
  if [ $ret -ne 0 ]; then
        echo "monting cifs" && mount -t cifs -o vers=1.0,username={USERNAME@DOMAIN,password='{PASSWORD}' '{//SERVER/SHARE}' /mnt/ \

  else
        echo "cifs already exists"
  fi
}


backup () {
  docker exec -t {CONTAINER NAME} pg_dumpall -c -U postgres | gzip > /mnt/db_dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql.gz \
  && mail_ok \
  || mail_x
}

do_it () {
    echo backup a dockerized PostgreSQL database
    echo .
    echo mount cifs share...
    mount_point \
    echo backup backup PostgreSQL to cifs...
    backup \
    echo clean olds backup...
    find /mnt/*gz -ctime +30 -exec rm {} \;
    echo done.
}

do_it
