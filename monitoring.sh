#!/bin/bash


#architecture
arch=$(uname -a)

#Number of physical and virtual CPU
CPU=$(grep "physical id" /proc/cpuinfo | wc -l)
vCPU=$(grep processor /proc/cpuinfo | wc -l)

#Memory usage
MemUs=$(free --mega | awk '$1 == "Mem:" {print $3}')
MemTot=$(free --mega | awk '$1 == "Mem:" {print $2}')
MemPerc=$(free --mega | awk '$1 == "Mem:" {printf("%.2f%%\n", $3/$2*100)}')

#Disk usage
DiskUs=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use += $3} END {print memory_use}')
DiskTot=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_total += $2} END {printf ("%.0fGb\n"), memory_total/1024}')
DiskPerc=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_total += $2} {memory_use += $3} END {printf ("%d%%\n"), memory_use/memory_total*100}')

#CPU load
cpu_idle=$(vmstat | tail -1 | awk '{print $15}')
cpu_op=$(100 - cpu_idle)
CPU_load=$(printf "%.1f%%" "$cpu_op")

#last boot
lstBoot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

#LVM confirmation
LVM=$(if lsblk | grep -q "lvm"; then echo "yes"; else echo "no"; fi)

#tcp connections
TCP_conn=$(ss -ta | grep "ESTAB" | wc -l)

#users logged in
UsrLog=$(users | wc -w)

#ip and mac adresses
IP=$(hostname -I | awk '{print $1}')
Mac=$(ip link show | awk '/ether/ {print $2}')

#number of sudo commands on log
SudoCmd=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)

wall "	#Architecture: $arch
	#CPU physical: $CPU
	#vCPU: $vCPU
	#Memory Usage: $MemUs/${MemTot}MB ($MemPerc)
	#Disk Usage: $DiskUs/$DiskTot ($DiskPerc)
	#CPU load: $CPU_load
	#Last boot: $lstBoot
	#LVM use: $LVM
	#Connections TCP: $TCP_conn ESTABLISHED
	#User log: $UsrLog
	#Network: IP $IP ($Mac)
	#Sudo: $SudoCmd cmd"
