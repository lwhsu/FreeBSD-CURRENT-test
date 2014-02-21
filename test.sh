#!/bin/sh

VM_NAME=sandbox

VBoxHeadless -startvm ${VM_NAME} &
sleep 30

echo "${VM_NAME} started"

echo "Begin test"
ssh -i /usr/local/jenkins/.ssh/id_rsa 192.168.56.104 'uname -a'
ssh -i /usr/local/jenkins/.ssh/id_rsa 192.168.56.104 'dmesg'
echo "Test Over"

VBoxManage controlvm ${VM_NAME} acpipowerbutton

wait
