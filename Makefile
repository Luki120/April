export ARCHS = arm64 arm64e
export TARGET := iphone:clang:latest:latest

DEBUG = 0
FINALPACKAGE = 1

INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = April

April_FILES = Tweak.x
April_CFLAGS = -fobjc-arc
April_FRAMEWORKS = UIKit

export April_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += AprilPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk