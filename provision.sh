#!/bin/sh

VM_FOLDER=~/VirtualBox\ VMs/${VM_NAME}
VM_NAME=sandbox

VBoxManage createvm --name ${VM_NAME} --ostype "FreeBSD_64" --register

VBoxManage modifyvm ${VM_NAME} --cpus 2
VBoxManage modifyvm ${VM_NAME} --chipset ich9
VBoxManage modifyvm ${VM_NAME} --ioapic on
VBoxManage modifyvm ${VM_NAME} --rtcuseutc on
VBoxManage modifyvm ${VM_NAME} --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm ${VM_NAME} --memory 1024 --vram 8

VBoxManage storagectl ${VM_NAME} --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage createhd --filename "${VM_FOLDER}/${VM_NAME}.vdi" --size 32768
VBoxManage storageattach ${VM_NAME} --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${VM_FOLDER}/${VM_NAME}.vdi"
#VBoxManage storageattach ${VM_NAME} --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium emptydrive

VBoxManage modifyvm ${VM_NAME} --nic1 nat --nictype1 virtio
VBoxManage modifyvm ${VM_NAME} --nic2 hostonly --nictype2 virtio --hostonlyadapter2 vboxnet0

fetch http://127.0.0.1:8180/jenkins/job/FreeBSD-CURRENT/lastSuccessfulBuild/artifact/obj/disc1.iso

VBoxManage storageattach ${VM_NAME} --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium ./disc1.iso

VBoxHeadless -startvm ${VM_NAME} &

echo "${VM_NAME} started"

# wait for install...
# XXX: need to find a way to know when installation is done
sleep 180

VBoxManage controlvm ${VM_NAME} acpipowerbutton

VBoxManage storageattach ${VM_NAME} --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium emptydrive

wait

echo "${VM_NAME} provisioned"
