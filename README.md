# meta-aaeon-qcom

This is a test layer for Aaeons ucom-6490.



# Dependencies

This layer has only been tested with Qualcoms SDK for qcom6490 version 1.6:

    https://docs.qualcomm.com/doc/80-70022-254/topic/github_workflow_unregistered_users.html?product=895724676033554725&facet=Build%20Guide&version=1.6



# Setting up and building

    repo init -u https://github.com/quic-yocto/qcom-manifest -b qcom-linux-scarthgap -m qcom-6.6.97-QLI.1.6-Ver.1.2.xml
    repo sync
Since this test layer has only been tested with Qualcoms SDK we need to manually enter our layer:
     
    git clone https://github.com/wwtri/meta-aaeon-qcom.git layers/

We can then setup the environment using the setup-environment script:

    MACHINE=qcs6490-rb3gen2-vision-kit DISTRO=qcom-wayland QCOM_SELECTED_BSP=custom source setup-environment


Add our meta-aaeon-qcom to the bitbake server:

    nano conf/bblayers:
    EXTRALAYERS ?= " \
    ${WORKSPACE}/layers/meta-aaeon-qcom \
    "

We can then build the demo image with:

    $bitbake qcom-multimedia-image

# Flashing the image to eMMC



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


 
