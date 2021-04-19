export ARCHS = arm64 arm64e
export TARGET := iphone:clang:latest:latest

DEBUG = O
FINALPACKAGE = 1

INSTALL_TARGET_PROCESSES = Preferences

#THEOS_DEVICE_IP = 192.168.0.7
THEOS_DEVICE_IP = 192.168.0.12

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = April

April_FILES = Tweak.x
April_CFLAGS = -fobjc-arc
April_FRAMEWORKS = UIKit

export April_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += aprilprefs
include $(THEOS_MAKE_PATH)/aggregate.mk