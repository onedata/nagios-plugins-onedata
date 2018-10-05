
PKGNAME=nagios-plugins-onedata
SPECFILE=${PKGNAME}.spec
FILES=Makefile ${SPECFILE} src

PKGVERSION=$(shell git describe --tags --always)

dist:
	rm -rf dist
	mkdir -p dist/${PKGNAME}-${PKGVERSION}
	sed -i "s/{{version}}/$(PKGVERSION)/g" ${SPECFILE}
	cp -pr ${FILES} dist/${PKGNAME}-${PKGVERSION}/.
	cd dist ; tar cfz ../${PKGNAME}-${PKGVERSION}.tar.gz ${PKGNAME}-${PKGVERSION}
	rm -rf dist

sources: dist

clean:
	rm -rf ${PKGNAME}-${PKGVERSION}.tar.gz
	rm -rf dist
