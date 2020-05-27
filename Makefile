# instantWM - window manager for instantOS
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c instantwm.c util.c
OBJ = ${SRC:.c=.o}

all: options instantwm

options:
	@echo instantwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

instantwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f instantwm ${OBJ} instantwm-${VERSION}.tar.gz

dist: clean
	mkdir -p instantwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		instantwm.1 drw.h util.h ${SRC} transient.c instantwm-${VERSION}
	tar -cf instantwm-${VERSION}.tar instantwm-${VERSION}
	gzip instantwm-${VERSION}.tar
	rm -rf instantwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f instantwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/instantwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < instantwm.1 > ${DESTDIR}${MANPREFIX}/man1/instantwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/instantwm.1
	cp instantwm.desktop /usr/share/xsessions

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/instantwm\
		${DESTDIR}${MANPREFIX}/man1/instantwm.1

.PHONY: all options clean dist install uninstall
