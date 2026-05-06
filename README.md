# meta-aaeon-qcom

This is a test layer for Aaeons ucom-6490.



# Dependencies

This layer has only been tested with Qualcoms SDK for qcom6490 version 1.6:

    https://docs.qualcomm.com/doc/80-70022-254/topic/github_workflow_unregistered_users.html?product=895724676033554725&facet=Build%20Guide&version=1.6



# Setting up and building

    repo init -u https://github.com/quic-yocto/qcom-manifest -b qcom-linux-scarthgap -m qcom-6.6.97-QLI.1.6-Ver.1.2.xml
    repo sync
Since this test layer has only been tested with Qualcoms SDK we need to manually enter our layer:
     
    git clone https://github.com/wwtri/meta-aaeon-qcom.git layers/meta-aaeon-qcom

We can then setup the environment using the setup-environment script:

    MACHINE=qcs6490-rb3gen2-vision-kit DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment


Add our meta-aaeon-qcom to the bitbake server:

    nano conf/bblayers:
    EXTRALAYERS ?= " \
    ${WORKSPACE}/layers/meta-aaeon-qcom \
    "

We can then build the demo image with:

    $bitbake qcom-multimedia-image

# Flashing the image to UFS



Once the image is built we can flash it to the module with the Qualcomm tool QDL, which can be downloaded here:
https://softwarecenter.qualcomm.com/catalog/item/Qualcomm_Device_Loader

## Prepairing the carrier
For flashing on AAeons carrier ECB-960T make sure to set switch SW5:

    SW5
    ***************
    OFF ON ON 
    ***************

    J16
    ********************
    Short pin pin3->pin5
    short pin pin4->pin6
    *********************

Connect a USB-micro cable to CN41 and power on the carrier, make sure it identifies correctly:

    [413876.232193] usb 1-10: new high-speed USB device number 21 using xhci_hcd
    [413876.361494] usb 1-10: New USB device found, idVendor=05c6, idProduct=9008, bcdDevice= 0.00
    [413876.361495] usb 1-10: New USB device strings: Mfr=1, Product=2, SerialNumber=0
    [413876.361496] usb 1-10: Product: QUSB_BULK_CID:042F_SN:DD9EC526
    [413876.361497] usb 1-10: Manufacturer: Qualcomm CDMA Technologies MSM
    [413876.376100] usbcore: registered new interface driver qcserial
    [413876.376110] usbserial: USB Serial support registered for Qualcomm USB modem
    [413876.376120] qcserial 1-10:1.0: Qualcomm USB modem converter detected
    [413876.376158] usb 1-10: Qualcomm USB modem converter now attached to ttyUSB0


We can now flash the image, make sure to stand in the correct folder:
     
     build-qcom-wayland/tmp-glibc/deploy/images/qcs6490-rb3gen2-vision-kit/qcom-multimedia-image$

We can then run the flash tool with:

    $ /<path_to>/<your_qdl_folder>/qdl --storage ufs prog_firehose_ddr.elf rawprogram*.xml patch*.xml
    waiting for programmer...
    flashed "efi" successfully at 37449kB/s                                          
    flashed "system" successfully at 38405kB/s                                      
    flashed "PrimaryGPT" successfully                                                
    flashed "BackupGPT" successfully                                                 
    flashed "xbl_a" successfully                                                     
    flashed "xbl_config_a" successfully                                              
    flashed "PrimaryGPT" successfully                                                
    flashed "BackupGPT" successfully                                                 
    flashed "xbl_a" successfully                                                     
    flashed "xbl_config_a" successfully                                              
    flashed "PrimaryGPT" successfully                                                
    flashed "BackupGPT" successfully                                                 
    flashed "PrimaryGPT" successfully                                                
    flashed "BackupGPT" successfully                                                 
    flashed "aop_a" successfully                                                     
    flashed "dtb_a" successfully at 32768kB/s                                       
    flashed "xbl_ramdump_a" successfully                                             
    flashed "uefi_a" successfully                                                    
    flashed "tz_a" successfully                                                     
    flashed "hyp_a" successfully at 1496kB/s                                        
    flashed "devcfg_a" successfully                                                  
    flashed "qupfw_a" successfully                                                   
    flashed "uefisecapp_a" successfully                                              
    flashed "imagefv_a" successfully                                                 
    flashed "shrm_a" successfully                                                    
    flashed "multiimgoem_a" successfully                                             
    flashed "cpucp_a" successfully                                                   
    flashed "toolsfv" successfully                                                   
    flashed "PrimaryGPT" successfully                                                
    flashed "BackupGPT" successfully                                                 
    flashed "PrimaryGPT" successfully                                                
    flashed "BackupGPT" successfully                                                 
    78 patches applied                                                              
    partition 1 is now bootable

# Booting



Set SW5 to:

    SW5
    ***************
    ON ON ON 
    ***************

Connect a serial adapter to SER3:

Debug port (SER3):
    
    pin 1: NC
    pin 2: RX
    pin 3: TX
    pin 4: GND
    pin 5: NC

Power upp the board and it should boot into linux:

    Qualcomm Linux 1.6-ver.1.2 qcs6490-rb3gen2-vision-kit ttyMSM0
    qcs6490-rb3gen2-vision-kit login: 
The default user/password is : root/oelinux123


 # Testing

## Ethernet

### eth0
 
        root@qcs6490-rb3gen2-vision-kit:~# [ 3151.479753][    C1] tc956x_pci-eth 0001:05:00.0: tc956xmac_wol_interrupt
        [ 3151.486841][ T2245] tc956x_pci-eth 0001:05:00.0: Entry: tc956xmac_defer_phy_isr_work
        [ 3151.498757][ T2245] tc956x_pci-eth 0001:05:00.0: Exit: tc956xmac_defer_phy_isr_work
        [ 3151.778584][    C1] tc956x_pci-eth 0001:05:00.0: tc956xmac_wol_interrupt
        [ 3151.785665][ T2245] tc956x_pci-eth 0001:05:00.0: Entry: tc956xmac_defer_phy_isr_work
        [ 3151.798739][ T2245] tc956x_pci-eth 0001:05:00.0: Exit: tc956xmac_defer_phy_isr_work
        [ 3152.336068][    C1] tc956x_pci-eth 0001:05:00.0: tc956xmac_wol_interrupt
        [ 3152.343153][ T2245] tc956x_pci-eth 0001:05:00.0: Entry: tc956xmac_defer_phy_isr_work
        [ 3152.354201][ T2245] tc956x_pci-eth 0001:05:00.0: Exit: tc956xmac_defer_phy_isr_work
        [ 3152.416500][    C1] tc956x_pci-eth 0001:05:00.0: tc956xmac_wol_interrupt
        [ 3152.423570][ T2245] tc956x_pci-eth 0001:05:00.0: Entry: tc956xmac_defer_phy_isr_work
        [ 3152.431960][ T2245] tc956x_pci-eth 0001:05:00.0: Exit: tc956xmac_defer_phy_isr_work
        [ 3152.445913][ T2297] tc956x_pci-eth 0001:05:00.0: tc956xmac_mac_link_up priv->eee_enabled: 0 priv->eee_active: 0

 Testing the speed:

    root@qcs6490-rb3gen2-vision-kit:~# iperf3 -c 192.168.1.32 -t 10
    Connecting to host 192.168.1.32, port 5201
    [  5] local 192.168.1.232 port 52672 connected to 192.168.1.32 port 5201
    [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
    [  5]   0.00-1.00   sec   114 MBytes   957 Mbits/sec    0    365 KBytes       
    [  5]   1.00-2.00   sec   112 MBytes   938 Mbits/sec    0    365 KBytes       
    [  5]   2.00-3.00   sec   112 MBytes   940 Mbits/sec    0    365 KBytes       
    [  5]   3.00-4.00   sec   112 MBytes   944 Mbits/sec    0    365 KBytes       
    [  5]   4.00-5.00   sec   112 MBytes   942 Mbits/sec    0    365 KBytes       
    [  5]   5.00-6.00   sec   112 MBytes   943 Mbits/sec    0    365 KBytes       
    [  5]   6.00-7.00   sec   112 MBytes   937 Mbits/sec    0    365 KBytes       
    [  5]   7.00-8.00   sec   112 MBytes   942 Mbits/sec    0    365 KBytes       
    [  5]   8.00-9.00   sec   112 MBytes   942 Mbits/sec    0    365 KBytes       
    [  5]   9.00-10.00  sec   112 MBytes   941 Mbits/sec    0    365 KBytes       
    - - - - - - - - - - - - - - - - - - - - - - - - -
    [ ID] Interval           Transfer     Bitrate         Retr
    [  5]   0.00-10.00  sec  1.10 GBytes   942 Mbits/sec    0            sender
    [  5]   0.00-10.00  sec  1.10 GBytes   941 Mbits/sec                  receiver
    
    iperf Done.
 
### eth1

Connecting ethernet cable:

    [ 3307.603623][    C0] tc956x_pci-eth 0001:05:00.1: tc956xmac_wol_interrupt
    [ 3307.610667][ T2299] tc956x_pci-eth 0001:05:00.1: Entry: tc956xmac_defer_phy_isr_work
    [ 3307.624406][ T2299] tc956x_pci-eth 0001:05:00.1: Exit: tc956xmac_defer_phy_isr_work
    [ 3307.949673][    C0] tc956x_pci-eth 0001:05:00.1: tc956xmac_wol_interrupt
    [ 3307.956732][ T2299] tc956x_pci-eth 0001:05:00.1: Entry: tc956xmac_defer_phy_isr_work
    [ 3307.970468][ T2299] tc956x_pci-eth 0001:05:00.1: Exit: tc956xmac_defer_phy_isr_work
    [ 3308.495957][    C0] tc956x_pci-eth 0001:05:00.1: tc956xmac_wol_interrupt
    [ 3308.502989][ T2299] tc956x_pci-eth 0001:05:00.1: Entry: tc956xmac_defer_phy_isr_work
    [ 3308.516512][ T2299] tc956x_pci-eth 0001:05:00.1: Exit: tc956xmac_defer_phy_isr_work
    [ 3308.556881][    C0] tc956x_pci-eth 0001:05:00.1: tc956xmac_wol_interrupt
    [ 3308.563894][ T2299] tc956x_pci-eth 0001:05:00.1: Entry: tc956xmac_defer_phy_isr_work
    [ 3308.576745][ T2299] tc956x_pci-eth 0001:05:00.1: Exit: tc956xmac_defer_phy_isr_work
    [ 3308.589755][   T89] tc956x_pci-eth 0001:05:00.1: tc956xmac_mac_link_up priv->eee_enabled: 0 priv->eee_active: 0

Testing speed with iperf3:

    root@qcs6490-rb3gen2-vision-kit:~# iperf3 -c 192.168.1.32 -t 10
    Connecting to host 192.168.1.32, port 5201
    [  5] local 192.168.1.162 port 35096 connected to 192.168.1.32 port 5201
    [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
    [  5]   0.00-1.00   sec   114 MBytes   951 Mbits/sec    0    368 KBytes       
    [  5]   1.00-2.00   sec   112 MBytes   940 Mbits/sec    0    368 KBytes       
    [  5]   2.00-3.00   sec   112 MBytes   942 Mbits/sec    0    368 KBytes       
    [  5]   3.00-4.00   sec   113 MBytes   948 Mbits/sec    0    368 KBytes       
    [  5]   4.00-5.00   sec   112 MBytes   941 Mbits/sec    0    368 KBytes       
    [  5]   5.00-6.00   sec   112 MBytes   939 Mbits/sec    0    368 KBytes       
    [  5]   6.00-7.00   sec   112 MBytes   941 Mbits/sec    0    368 KBytes       
    [  5]   7.00-8.00   sec   112 MBytes   944 Mbits/sec    0    393 KBytes       
    [  5]   8.00-9.00   sec   112 MBytes   941 Mbits/sec    0    393 KBytes       
    [  5]   9.00-10.00  sec   112 MBytes   940 Mbits/sec    0    393 KBytes       
    - - - - - - - - - - - - - - - - - - - - - - - - -
    [ ID] Interval           Transfer     Bitrate         Retr
    [  5]   0.00-10.00  sec  1.10 GBytes   943 Mbits/sec    0            sender
    [  5]   0.00-10.00  sec  1.10 GBytes   941 Mbits/sec                  receiver
    
    iperf Done.

## USB

### USB2.0 ports (CN8 on ECB-960T-A17)

Connect USB drive on upper port:

    root@qcs6490-rb3gen2-vision-kit:~# dmesg | tail -n 10
    [ 3619.158761] usb-storage 1-1.3:1.0: USB Mass Storage device detected
    [ 3619.162580] scsi host1: usb-storage 1-1.3:1.0
    [ 3620.176586] scsi 1:0:0:0: Direct-Access     VendorCo ProductCode      2.00 PQ: 0 ANSI: 4
    [ 3620.181607] sd 1:0:0:0: [sdi] 61440000 512-byte logical blocks: (31.5 GB/29.3 GiB)
    [ 3620.181846] sd 1:0:0:0: [sdi] Write Protect is off
    [ 3620.181857] sd 1:0:0:0: [sdi] Mode Sense: 03 00 00 00
    [ 3620.182075] sd 1:0:0:0: [sdi] No Caching mode page found
    [ 3620.182085] sd 1:0:0:0: [sdi] Assuming drive cache: write through
    [ 3620.203797]  sdi: sdi1 sdi2
    [ 3620.205472] sd 1:0:0:0: [sdi] Attached SCSI removable disk
    root@qcs6490-rb3gen2-vision-kit:~# sudo mount /dev/sdi2 /mnt
    -sh: sudo: command not found
    root@qcs6490-rb3gen2-vision-kit:~# mount /dev/sdi2 /mnt
    root@qcs6490-rb3gen2-vision-kit:~# echo "test" > /mnt/test.txt
    root@qcs6490-rb3gen2-vision-kit:~# umount /mnt

Connect USB drive on lower port:

    root@qcs6490-rb3gen2-vision-kit:~# dmesg | tail -n 10
    [ 3805.017727] usb-storage 1-1.1:1.0: USB Mass Storage device detected
    [ 3805.023961] scsi host1: usb-storage 1-1.1:1.0
    [ 3806.038146] scsi 1:0:0:0: Direct-Access     VendorCo ProductCode      2.00 PQ: 0 ANSI: 4
    [ 3806.047319] sd 1:0:0:0: [sdi] 61440000 512-byte logical blocks: (31.5 GB/29.3 GiB)
    [ 3806.047633] sd 1:0:0:0: [sdi] Write Protect is off
    [ 3806.047643] sd 1:0:0:0: [sdi] Mode Sense: 03 00 00 00
    [ 3806.047906] sd 1:0:0:0: [sdi] No Caching mode page found
    [ 3806.047915] sd 1:0:0:0: [sdi] Assuming drive cache: write through
    [ 3806.069308]  sdi: sdi1 sdi2
    [ 3806.071016] sd 1:0:0:0: [sdi] Attached SCSI removable disk
    root@qcs6490-rb3gen2-vision-kit:~# mount /dev/sdi2 /mnt
    root@qcs6490-rb3gen2-vision-kit:~# cat /mnt/test.txt 
    test
    root@qcs6490-rb3gen2-vision-kit:~# umount /mnt

### USB2.0 ports (CN9 on ECB-960T-A17)

Connect USB drive on lower port (upper port not supported):

    root@qcs6490-rb3gen2-vision-kit:~# dmesg | tail -n 10
    [ 3966.812607] usb-storage 1-1.4:1.0: USB Mass Storage device detected
    [ 3966.820389] scsi host1: usb-storage 1-1.4:1.0
    [ 3967.836130] scsi 1:0:0:0: Direct-Access     VendorCo ProductCode      2.00 PQ: 0 ANSI: 4
    [ 3967.845825] sd 1:0:0:0: [sdi] 61440000 512-byte logical blocks: (31.5 GB/29.3 GiB)
    [ 3967.846071] sd 1:0:0:0: [sdi] Write Protect is off
    [ 3967.846082] sd 1:0:0:0: [sdi] Mode Sense: 03 00 00 00
    [ 3967.846313] sd 1:0:0:0: [sdi] No Caching mode page found
    [ 3967.846323] sd 1:0:0:0: [sdi] Assuming drive cache: write through
    [ 3967.866122]  sdi: sdi1 sdi2
    [ 3967.868471] sd 1:0:0:0: [sdi] Attached SCSI removable disk

### USB2.0 port (CN16 on ECB-960T-A17)

    root@qcs6490-rb3gen2-vision-kit:~# dmesg | tail -n 10
    [ 4114.265789] usb-storage 1-1.2:1.0: USB Mass Storage device detected
    [ 4114.271897] scsi host1: usb-storage 1-1.2:1.0
    [ 4115.293107] scsi 1:0:0:0: Direct-Access     VendorCo ProductCode      2.00 PQ: 0 ANSI: 4
    [ 4115.298051] sd 1:0:0:0: [sdi] 61440000 512-byte logical blocks: (31.5 GB/29.3 GiB)
    [ 4115.298371] sd 1:0:0:0: [sdi] Write Protect is off
    [ 4115.298382] sd 1:0:0:0: [sdi] Mode Sense: 03 00 00 00
    [ 4115.298604] sd 1:0:0:0: [sdi] No Caching mode page found
    [ 4115.298653] sd 1:0:0:0: [sdi] Assuming drive cache: write through
    [ 4115.318966]  sdi: sdi1 sdi2
    [ 4115.320137] sd 1:0:0:0: [sdi] Attached SCSI removable disk

## Display

### Display Port (DP0 lane0 on ECB-960T-A17)

Display works on boot and we can check the init_display.service to verify it runs correctly:


    root@qcs6490-rb3gen2-vision-kit:~# systemctl status init_display.service
    * init_display.service - Init-display Service
         Loaded: loaded (/etc/initscripts/init_qti_display; enabled; preset: disabled)
         Active: active (exited) since Thu 2025-05-29 18:48:29 UTC; 6min ago
        Process: 628 ExecStartPre=/bin/mkdir -p /dev/socket/weston (code=exited, status=0/SUCCESS)
        Process: 877 ExecStartPre=/bin/sh -c if selinuxenabled && command -v restorecon >/dev/null 2>&1; then /sbin/restorecon -F /dev/socket/weston; fi (code=exited, status=0/SUCCESS)
        Process: 912 ExecStartPre=/bin/chown root:root /dev/socket/weston (code=exited, status=0/SUCCESS)
        Process: 921 ExecStartPre=/bin/chmod 0700 /dev/socket/weston (code=exited, status=0/SUCCESS)
        Process: 930 ExecStartPre=/bin/modetest -c (code=exited, status=0/SUCCESS)
        Process: 951 ExecStartPre=/bin/sleep 2 (code=exited, status=0/SUCCESS)
        Process: 1299 ExecStartPre=/bin/mkdir -p /dev/dri (code=exited, status=0/SUCCESS)
        Process: 1302 ExecStartPre=/bin/chmod 0755 /dev/dri (code=exited, status=0/SUCCESS)
        Process: 1304 ExecStart=/etc/initscripts/init_qti_display start (code=exited, status=0/SUCCESS)
       Main PID: 1304 (code=exited, status=0/SUCCESS)
          Tasks: 12 (limit: 18183)
         Memory: 135.8M (peak: 144.0M)
            CPU: 12.947s
         CGroup: /system.slice/init_display.service
                 |-1313 weston --backend=drm-backend.so --renderer=pixman --idle-time=0 --continue-without-input
                 |-1316 weston --backend=drm-backend.so --renderer=pixman --idle-time=0 --continue-without-input
                 |-1318 /usr/libexec/weston-keyboard
                 |-1319 /usr/libexec/weston-desktop-shell
                 |-2110 /bin/bash /usr/bin/Qdemo
                 |-2111 python3 /usr/bin/gst-gui-launcher-app.py
                 |-2126 /usr/bin/weston-terminal
                 `-2127 /bin/bash
