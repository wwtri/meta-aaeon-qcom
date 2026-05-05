FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://devcfg.mbn"

do_deploy:append() {

    install -m 0644 ${WORKDIR}/devcfg.mbn ${DEPLOYDIR}/devcfg.mbn
}