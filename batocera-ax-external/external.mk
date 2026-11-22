ifeq ($(BR2_PACKAGE_PICCOLO_AX_DESKTOP),y)
PICCOLO_DESKTOP_DIR := $(BR2_EXTERNAL_PICCOLO_AX_PATH)/../piccolo-ax-desktop
include $(PICCOLO_DESKTOP_DIR)/profiles/desktop-core.mk
include $(PICCOLO_DESKTOP_DIR)/profiles/desktop-heavy.mk
include $(sort $(wildcard $(PICCOLO_DESKTOP_DIR)/buildroot/package/*/*.mk))
endif
