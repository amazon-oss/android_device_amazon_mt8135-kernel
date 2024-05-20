LOCAL_PATH := $(call my-dir)

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(TARGET_PREBUILT_BOOTIMAGE) $(INSTALLED_RAMDISK_TARGET)
	$(call pretty,"Target boot image: $@  ${MKBOOTIMG} ${INTERNAL_BOOTIMAGE_ARGS} ${BOARD_MKBOOTIMG_ARGS}")
	@echo -e ${CL_CYN}"----- Making boot image ------"${CL_RST}
	@cp $(TARGET_PREBUILT_BOOTIMAGE) $@
	@echo -e ${CL_CYN}"----- Compressing ramdisk with LZMA ------"
	@mkdir -p $(PRODUCT_OUT)/ramdisk-temp $(PRODUCT_OUT)/system/etc
	@gzip -cd $(INSTALLED_RAMDISK_TARGET) | (cd $(PRODUCT_OUT)/ramdisk-temp && cpio -idm)
	@(cd $(PRODUCT_OUT)/ramdisk-temp && find . -print0 | cpio --null -ov -H newc | xz --format=lzma > $(PRODUCT_OUT)/system/etc/ramdisk.cpio.lzma)
	@rm -rf $(PRODUCT_OUT)/ramdisk-temp
	@echo -e ${CL_CYN}"Made compressed ramdisk: $(PRODUCT_OUT)/system/etc/ramdisk.cpio.lzma"${CL_RST}
	@echo -e ${CL_CYN}"Made boot image: $@"${CL_RST}

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(recovery_ramdisk) $(recovery_kernel)
	@echo -e ${CL_CYN}"----- Making recovery image ------"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"----- Compressing ramdisk with LZMA ------"
	@mkdir -p $(PRODUCT_OUT)/ramdisk-recovery-temp $(PRODUCT_OUT)/system/etc
	@gzip -cd $(recovery_ramdisk) | (cd $(PRODUCT_OUT)/ramdisk-recovery-temp && cpio -idm)
	@(cd $(PRODUCT_OUT)/ramdisk-recovery-temp && find . -print0 | cpio --null -ov -H newc | xz --format=lzma > $(PRODUCT_OUT)/system/etc/ramdisk-recovery.cpio.lzma)
	@rm -rf $(PRODUCT_OUT)/ramdisk-recovery-temp
	@echo -e ${CL_CYN}"Made compressed ramdisk: $(PRODUCT_OUT)/system/etc/ramdisk-recovery.cpio.lzma"${CL_RST}
	@echo -e ${CL_CYN}"Made recovery image: $@"${CL_RST}

