export TARGET=iphone:clang
TARGET = iphone:clang:10.3:10.0
GO_EASY_ON_ME = 1
ARCHS = armv7 arm64
DEBUG = 0
PACKAGE_VERSION=1.0-Beta-2

THEOS=/opt/theos

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Melody
$(TWEAK_NAME)_FILES = $(wildcard Extensions/*.m) $(wildcard Classes/*.m) $(wildcard Classes/*.xm) Tweak.xm
$(TWEAK_NAME)_FRAMEWORKS = UIKit
$(TWEAK_NAME)_LDFLAGS += -F./ -lMobileGestalt -F./Extensions/ -F./Classes/
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -F./Extensions/ -F./Classes/

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Settings
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall Music; sblaunch com.apple.Music"

