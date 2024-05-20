DEVICE_KERNEL_PATH := device/amazon/mt8135-kernel

# Modules
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_KERNEL_PATH)/modules,$(TARGET_COPY_OUT_SYSTEM)/lib/modules)
