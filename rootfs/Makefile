include ../Makefile.header

HDA_IMG_FLAG := $(shell find ./ -name $(HDA_IMG))
FLP_IMG_FLAG := $(shell find ./ -name $(FLP_IMG))
RAM_IMG_FLAG := $(shell find ./ -name $(RAM_IMG))

hda: $(HDA_IMG).$(IMG_SUFFIX)
ifeq ($(HDA_IMG_FLAG),)
	@tar Jvxf $<
endif

flp: $(FLP_IMG).$(IMG_SUFFIX)
ifeq ($(FLP_IMG_FLAG),)
	@tar Jvxf $<
endif

ramfs: $(RAM_IMG).$(IMG_SUFFIX)
ifeq ($(RAM_IMG_FLAG),)
	@tar Jvxf $<
endif

clean:
	@rm -f $(HDA_IMG)
	@rm -f $(FLP_IMG)
	@rm -f $(RAM_IMG)
