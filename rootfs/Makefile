include ../Makefile.header

HDA_IMG_FLAG := $(shell find ./ -name $(HDA_IMG))
FLP_IMG_FLAG := $(shell find ./ -name $(FLP_IMG))
RAM_IMG_FLAG := $(shell find ./ -name $(RAM_IMG))

hda: $(HDA_IMG).xz
ifeq ($(HDA_IMG_FLAG),)
	@tar Jvxf $< &>/dev/null
endif

flp: $(FLP_IMG).xz
ifeq ($(FLP_IMG_FLAG),)
	@tar Jvxf $< &>/dev/null
endif

ramfs: $(RAM_IMG).xz
ifeq ($(RAM_IMG_FLAG),)
	@tar Jvxf $< &>/dev/null
endif

clean:
	@rm -f $(HDA_IMG)
	@rm -f $(FLP_IMG)
	@rm -f $(RAM_IMG)
