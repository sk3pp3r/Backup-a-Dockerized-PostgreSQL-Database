# Backup-a-Dockerized-PostgreSQL-Database
## Backup a Dockerized PostgreSQL Database Script

add this script tou your crontab, add permissions (if needed)
You need to replace each {ITEM} with relevant information
This script test on RHEL 8 with Docker version 19.03.13
to ad a daily cron job do the following steps:
```
sudo crontab -e
@daily /bin/bash {script location}backup_postgres.sh >/dev/null 2>&1
```