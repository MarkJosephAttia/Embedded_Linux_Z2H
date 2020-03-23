echo "auto eth0" >> ${TARGET_DIR}/etc/network/interfaces
echo "iface eth0 inet static" >> ${TARGET_DIR}/etc/network/interfaces
echo "address 192.168.1.6" >> ${TARGET_DIR}/etc/network/interfaces
echo "netmask 255.255.255.0" >> ${TARGET_DIR}/etc/network/interfaces
