DEVICE_KERNEL_PATH := device/amazon/mt8135-kernel

# Modules
PRODUCT_COPY_FILES += \
    $(foreach dir,$(wildcard $(DEVICE_KERNEL_PATH)/modules/*),\
        $(call find-copy-subdir-files,*,$(dir),$(TARGET_COPY_OUT_SYSTEM)/lib/modules))
