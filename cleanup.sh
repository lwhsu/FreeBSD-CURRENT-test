#!/bin/sh

VM_NAME=sandbox

VBoxManage controlvm ${VM_NAME} acpipowerbutton

VBoxManage unregistervm ${VM_NAME} --delete
