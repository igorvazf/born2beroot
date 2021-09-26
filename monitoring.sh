#!bin/bash

echo "#Architecture: $(uname -a)"
echo "#CPU physical: $(grep 'physical id' /proc/cpuinfo | uniq | wc -l)"
echo "#vCPU: $(grep 'processor' /proc/cpuinfo | uniq | wc -l)"

USED_MEM=$(free -m | grep Mem: | awk '{print $3}')
TOTAL_MEM=$(free -m | grep Mem: | awk '{print$2}')
PCT_MEM=$(free -m | grep Mem: | awk '{printf("%.2f"), $3/$2*100}')
echo "#Memory Usage: ${USED_MEM}/${TOTAL_MEM}MB ($PCT_MEM}%)"

USED_DISK=$(df -Bm | grep /dev/ | grep -v /boot | awk '{ud += $3} END {print ud}')
TOTAL_DISK=$(df -Bg | grep /dev/ | grep -v /boot | awk '{fd += $2} END {print fd}')
PCT_DISK=$(df -Bm | grep /dev/ | grep -v /boot | awk '{ud += $3} {fd += $2} END {printf("%d"), ud/fd*100}')
echo "#Disk Usage: ${USED_DISK}/${TOTAL_DISK}Gb (${PCT_DISK}%)"

echo "#CPU load: $(top -bn1 | awk 'NR == 3 {printf "%d%%", $2 + $4}')"
echo "#Last boot: $(who -b | awk '{print $3,$4}')"
echo "#LVM use: $(lsblk | grep -q '1vm' && echo yes || echo no)"
echo "#Connexions TCP: $(ss -s | awk '$1 == "TCP:" {gsub(/,/,""); print $4 " ESTABLISHED"}')"
echo "#User log: $(who | wc -l)"

IP_ADDR=$(hostname -I)
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}')
echo "#Network: IP ${IP_ADDR} (${MAC})"

echo "#Sudo: $(grep -c 'COMMAND' /var/log/sudo/sudo_log) cmd"
