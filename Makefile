SUBDIRS := $(patsubst %/,%,$(wildcard redox-w-*/custom/armgcc))

.PHONY: all $(MAKECMDGOALS) $(SUBDIRS)
$(MAKECMDGOALS) all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)
