ARCHS := arm64e
TARGET := iphone:clang:latest:16.0
INSTALL_TARGET_PROCESSES = kawkaw

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = kawkaw

kawkaw_FILES = main.m kawkawAppDelegate.m kawkawExploit.m \
	exploit/poc.c exploit/socket.c exploit/surface.c \
	exploit/phys_oob.c exploit/krw.c exploit/kmem.c \
	exploit/free_thread.c exploit/utils.c exploit/kawkaw_offsets.c
kawkaw_CFLAGS = -fobjc-arc -I$(SRCROOT)/exploit -I$(SRCROOT) -Wno-unused-function -Wno-deprecated-declarations
kawkaw_CODESIGN_FLAGS = -Sentitlements.plist
kawkaw_RESOURCE_FILES = Resources
kawkaw_INFO_PLIST = Info.plist

include $(THEOS)/makefiles/application.mk

after-install::
	install.exec "uicache -a || true"
	install.exec "sbreload || true"
