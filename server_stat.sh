#!/bin/sh

#####
# This script show server utilization and available system disk space
# You can put it into /etc/profile to be executed on every login:
# example: echo "<script_path>" >> /etc/profile
#####
MACHINE=`uname -rn`
CPUTIME=$(ps -eo pcpu | awk 'NR>1' | awk '{tot=tot+$1} END {print tot}')
CPUCORES=$(cat /proc/cpuinfo | grep -c processor)
OSVERSION=$(cat /etc/system-release | awk {'print $7'} | awk -F. {'print $1'})
CURRENT_USERS=$(uptime | awk -F,  {'print $3'} | awk {'print $1'})
echo "
#########################Current Server Utilization#########################
`uptime`
- CPU Usage                = $CPUTIME% ($CPUCORES Cores)
- Memory free (real)       = `free -m | head -n 2 | tail -n 1 | awk {'print $4'}` Mb
- Memory free (cache)      = `free -m | head -n 2 | tail -n 1 | awk {'print $7'}` Mb
- Swap in use              = `free -m | tail -n 1 | awk {'print $3'}` Mb
- Disk Space Used:" 
[[ "$OSVERSION" -eq 6 ]] && echo "
                         / = `df -h  / | awk '{ a = $4 } END { print a }'`
                      /var = `df -h  /var | awk '{ a = $4 } END { print a }'`
                      /opt = `df -h  /opt | awk '{ a = $4 } END { print a }'` 
                      /usr = `df -h  /usr | awk '{ a = $4 } END { print a }'`"
[[ "$OSVERSION" -eq 7 ]] && echo "
                         / = `df -h  / | awk '{ a = $5 } END { print a }'`
                      /var = `df -h  /var | awk '{ a = $5 } END { print a }'`"
if [[ "$CURRENT_USERS" -ne 1  ]]
then
        echo "Currently logged in users:"
        for i in `/usr/bin/who | awk {'print $1'}`
        do
                echo "          $i : $(grep $i /etc/passwd | awk -F: {'print $5'} | awk -F, {'print $1'})"
        done
fi
echo "############################################################################"
