FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

#Add Aaeons prebuilt binaries to make sure we don't include the qualcom default

SRC_URI += "file://devcfg.mbn"
