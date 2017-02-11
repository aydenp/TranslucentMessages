export TARGET=iphone:clang
ARCHS = armv7 arm64
DEBUG = 1

THEOS=/opt/theos

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TranslucentMessages
$(TWEAK_NAME)_FILES = Tweak.xm DDTMColours.m
$(TWEAK_NAME)_FRAMEWORKS = UIKit
$(TWEAK_NAME)_LDFLAGS += -F./
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall MobileSMS;sblaunch com.apple.MobileSMS"
