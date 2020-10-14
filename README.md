# Backup-a-Dockerized-PostgreSQL-Database
## Backup a Dockerized PostgreSQL Database Script

Add this script tou your crontab, add permissions (if needed)    
You need to replace each {ITEM} with relevant information  
This script tested on RHEL 8 with Docker version 19.03.13  
  
to add a daily backup via cron job do the following steps:  
```
sudo crontab -e
@daily /bin/bash {script location}backup_postgres.sh >/dev/null 2>&1
```
