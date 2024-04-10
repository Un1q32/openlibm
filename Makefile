OPENLIBM_HOME=$(abspath .)
include ./Make.inc

SUBDIRS = src $(ARCH) bsdsrc
ifeq ($(LONG_DOUBLE_NOT_DOUBLE),1)
# Add ld80 directory on x86 and x64
ifneq ($(filter $(ARCH),i387 amd64),)
SUBDIRS += ld80
else
ifneq ($(filter $(ARCH),aarch64),)
SUBDIRS += ld128
else
endif
endif
endif

define INC_template
TEST=test
override CUR_SRCS = $(1)_SRCS
include $(1)/Make.files
SRCS += $$(addprefix $(1)/,$$($(1)_SRCS))
endef

DIR=test

$(foreach dir,$(SUBDIRS),$(eval $(call INC_template,$(dir))))

DUPLICATE_NAMES = $(filter $(patsubst %.S,%,$($(ARCH)_SRCS)),$(patsubst %.c,%,$(src_SRCS)))
DUPLICATE_SRCS = $(addsuffix .c,$(DUPLICATE_NAMES))

OBJS =  $(patsubst %.f,%.f.o,\
	$(patsubst %.S,%.S.o,\
	$(patsubst %.c,%.c.o,$(filter-out $(addprefix src/,$(DUPLICATE_SRCS)),$(SRCS)))))

.PHONY: all clean install install-static install-headers


OLM_LIBS := libopenlibm.a

all : $(OLM_LIBS)

libopenlibm.a: $(OBJS)
	$(AR) -rcs libopenlibm.a $(OBJS)

clean:
	rm -f libopenlibm.a aarch64/*.o amd64/*.o arm/*.o bsdsrc/*.o i387/*.o ld80/*.o ld128/*.o src/*.o

install-static: libopenlibm.a
	mkdir -p $(DESTDIR)$(libdir)
	cp -RpP -f libopenlibm.a $(DESTDIR)$(libdir)/libm.a

install-headers:
	mkdir -p $(DESTDIR)$(includedir)
	cp -RpP -f include/*.h $(DESTDIR)$(includedir)
	cp -RpP -f src/*.h $(DESTDIR)$(includedir)

install: install-static install-headers
