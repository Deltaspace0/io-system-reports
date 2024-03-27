#!/bin/bash

function mount_disks() {
    mkfs.ext4 /dev/mydisk1
    mkfs.ext4 /dev/mydisk5
    mkfs.ext4 /dev/mydisk6

    mkdir /mnt/mydisk1
    mkdir /mnt/mydisk5
    mkdir /mnt/mydisk6

    mount /dev/mydisk1 /mnt/mydisk1
    mount /dev/mydisk5 /mnt/mydisk5
    mount /dev/mydisk6 /mnt/mydisk6
}


function copy_random_to_disk() {
    dd if=/dev/urandom of=/mnt/mydisk1/file bs=1M count=5
    dd if=/dev/urandom of=/mnt/mydisk5/file bs=1M count=5
    dd if=/dev/urandom of=/mnt/mydisk6/file bs=1M count=5
}

function delete_files() {
    rm /mnt/mydisk1/file
    rm /mnt/mydisk5/file
    rm /mnt/mydisk6/file
}

function copy_from_virtual_to_virtual() {
    copy_random_to_disk
    echo "Copying files from virtual file to virtual file"
    pv /mnt/mydisk1/file > /mnt/mydisk5/file
    pv /mnt/mydisk5/file > /mnt/mydisk6/file
    pv /mnt/mydisk6/file > /mnt/mydisk1/file
    delete_files
}

function copy_between_virtual_and_real() {
    copy_random_to_disk
    echo "Copying files from virtual file to real file"
    mkdir test
    pv /mnt/mydisk1/file > test/1
    pv /mnt/mydisk5/file > test/5
    pv /mnt/mydisk6/file > test/6
    pv test/1 > /mnt/mydisk1/file
    pv test/5 > /mnt/mydisk5/file
    pv test/6 > /mnt/mydisk6/file
    delete_files
}

function final() {
    umount /mnt/mydisk1
    umount /mnt/mydisk5
    umount /mnt/mydisk6

    rmdir /mnt/mydisk1
    rmdir /mnt/mydisk5
    rmdir /mnt/mydisk6
}

mount_disks
copy_from_virtual_to_virtual
copy_between_virtual_and_real
final

