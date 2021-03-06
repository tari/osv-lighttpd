
version := lighttpd-1.4.35
tarball := $(version).tar.gz
url := http://download.lighttpd.net/lighttpd/releases-1.4.x/$(tarball)

.PHONY: module, lighttpd_mods
module: lighttpd.so lighttpd_mods
	rm -rf lighttpd
	mkdir lighttpd
	cp -Rv lighttpd.so lib/ lighttpd/

$(tarball):
	wget  -O $@ $(url)

$(version): $(tarball)
	tar xzf $^
	cd $(version) && CFLAGS=-fPIC ./configure --prefix=/lighttpd && make

# This is a terrible hack, literally duplicating the command that libtool runs
# but tweaked to generate a shared object.
OBJECTS:=server.o response.o connections.o network.o configfile.o configparser.o \
		request.o proc_open.o buffer.o log.o keyvalue.o chunk.o http_chunk.o \
		stream.o fdevent.o stat_cache.o plugin.o joblist.o etag.o array.o \
		data_string.o data_count.o data_array.o data_integer.o md5.o \
		data_fastcgi.o fdevent_select.o fdevent_libev.o fdevent_poll.o \
		fdevent_linux_sysepoll.o fdevent_solaris_devpoll.o \
		fdevent_solaris_port.o fdevent_freebsd_kqueue.o data_config.o bitset.o \
		inet_ntop_cache.o crc32.o connections-glue.o configfile-glue.o \
		http-header-glue.o network_write.o network_linux_sendfile.o \
		network_freebsd_sendfile.o network_writev.o network_solaris_sendfilev.o \
		network_openssl.o splaytree.o status_counter.o

OBJECTS:=$(addprefix $(version)/src/,$(OBJECTS))

lighttpd.so: $(version) $(OBJECTS)
	gcc -shared -fPIC -Wall -W -Wshadow -pedantic -std=gnu99 \
		-o lighttpd.so  -Wl,--export-dynamic  -lpcre -ldl \
		$(OBJECTS)

# Pretty sure we only need the shared objects and not libtool files.
lighttpd_mods: lighttpd.so
	rm -f lib/*
	mkdir -p lib
	cp lighttpd-1.4.35/src/.libs/*.so lib

clean:
	rm -rf lib lighttpd-1.4.35* lighttpd/ lighttpd.so
