name=test
version=1.0
SHELL=/bin/bash
PREFIX=/usr
DESTDIR=/
LIBDIR=/lib
links="-lglib-2.0"
build: clean
	mkdir -p build
	cd build ; valac -C `find ../src -type f -iname *.vala` --gir=$(name)-$(version).gir \
	    --library=$(name)  \
	    -H lib$(name).h
	for obj in `find . -type f -iname *.c` ; do \
	    $(CC) $(CFLAGS) -c $$obj -o $${obj/.c/.o} -fPIC;\
	done
	cd build; $(CC) $(CFLAGS) `find . -type f -iname *.o` $(links) -shared -o lib$(name).so
	g-ir-compiler build/$(name)-$(version).gir --shared-library=lib$(name) --output=build/$(name)-$(version).typelib
install:
	mkdir -p $(DESTDIR)/$(PREFIX)/$(LIBDIR)/girepository-1.0/
	install build/$(name)-$(version).typelib $(DESTDIR)/$(PREFIX)/$(LIBDIR)/girepository-1.0/
	install build/lib$(name).so $(DESTDIR)/$(PREFIX)/$(LIBDIR)/lib$(name).so

uninstall:
	rm -f $(DESTDIR)/$(PREFIX)/$(LIBDIR)/girepository-1.0/$(name)-$(version).typelib
	rm -f $(DESTDIR)/$(PREFIX)/$(LIBDIR)/lib$(name).so

test:
	python3 test.py

clean:
	rm -fr build
