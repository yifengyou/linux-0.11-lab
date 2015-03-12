include ../Makefile.header

HDA_IMG_FLAG := $(shell find ./ -name $(HDA_IMG))

hda: $(HDA_IMG).$(IMG_SUFFIX)
ifeq ($(HDA_IMG_FLAG),)
	@tar Jvxf $<
endif

clean:
	@rm -f $(HDA_IMG)
