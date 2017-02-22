export TARGET=iphone:clang
ARCHS = armv7 arm64
DEBUG = 0
PACKAGE_VERSION = 1.0.2

THEOS=/opt/theos

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TranslucentMessages
$(TWEAK_NAME)_FILES = Tweak.xm DDTMColours.m DDCustomAnimator.m DDCustomInteraction.m
$(TWEAK_NAME)_FRAMEWORKS = UIKit
$(TWEAK_NAME)_LDFLAGS += -F./
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Settings
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall MobileSMS Preferences"
