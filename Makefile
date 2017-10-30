NAME := wine
DIST := dist
SPEC := $(DIST)/SPECS/$(NAME).spec
SRCS := $(DIST)/SOURCES

rpm: clean helper
	rpmbuild -ba \
		--platform i686,x86_64 \
		--define "_topdir $(PWD)/$(DIST)" \
		$(SPEC)

srpm: clean helper
	rpmbuild -bs \
		--platform i686,x86_64 \
		--define "_topdir $(PWD)/$(DIST)" \
		$(SPEC)

prep: clean helper
	rpmbuild -bp \
		--platform i686,x86_64 \
		--define "_topdir $(PWD)/$(DIST)" \
		$(SPEC)

helper:
	mkdir -p $(DIST)/{BUILD,BUILDROOT,RPMS,SPECS,SOURCES,SRPMS}
	cp -f $(NAME).spec $(SPEC)
	cp -f * $(SRCS)
	spectool -g -A -f -C $(SRCS) $(SPEC) # https://stackoverflow.com/a/33177482

lint:
	rpmlint $(SPEC)

clean:
	rm -rf $(DIST)

install:
	sudo dnf install `find $(DIST)/RPMS/ -iname *.rpm`
