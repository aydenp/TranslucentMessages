export TARGET=iphone:clang
GO_EASY_ON_ME = 1
ARCHS = armv7 arm64
DEBUG = 1

THEOS=/opt/theos

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TranslucentMessages
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_FRAMEWORKS = UIKit
$(TWEAK_NAME)_LDFLAGS += -F./
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall MobileSMS;sblaunch com.apple.MobileSMS"
