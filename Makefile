export TARGET := iphone:clang:14.5:latest
INSTALL_TARGET_PROCESSES = Preferences

TWEAK_NAME = April

April_FILES = April.x
April_CFLAGS = -fobjc-arc
April_LIBRARIES = gcuniversal

SUBPROJECTS = AprilPrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
