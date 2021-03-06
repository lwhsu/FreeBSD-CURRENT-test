#!/bin/sh

VM_NAME=sandbox

VBoxHeadless -startvm ${VM_NAME} &
sleep 60

echo "${VM_NAME} started"

echo "Begin test"
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=1 -i /usr/local/jenkins/.ssh/id_rsa 192.168.56.105 'uname -a'
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=1 -i /usr/local/jenkins/.ssh/id_rsa 192.168.56.105 'dmesg'
echo "Test Over"

VBoxManage controlvm ${VM_NAME} acpipowerbutton

wait
