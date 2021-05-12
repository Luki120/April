TARGET := iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AprilPrefs

AprilPrefs_FILES = APRRootListController.m
AprilPrefs_FRAMEWORKS = UIKit
AprilPrefs_PRIVATE_FRAMEWORKS = Preferences
AprilPrefs_INSTALL_PATH = /Library/PreferenceBundles
AprilPrefs_CFLAGS = -fobjc-arc
#AprilPrefs_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/bundle.mk
