export ARCHS = arm64 arm64e
export TARGET := iphone:clang:latest:latest

INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = April

April_FILES = Tweak.x
April_CFLAGS = -fobjc-arc
April_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += AprilPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk