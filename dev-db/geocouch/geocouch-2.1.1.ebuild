EAPI=5

DESCRIPTION="${PN} from couchbase"
HOMEPAGE="https://www.couchbase.com"

SLOT="0"
SPN=couchbase-server
SPV=2.1.1
SRC_URI="http://packages.couchbase.com/releases/${SPV}/${SPN}_src-${SPV}.tar.gz"
LICENSE="COUCHBASE INC. COMMUNITY EDITION"
KEYWORDS="~x86 ~amd64"
IUSE=""

# FIXME
RDEPEND=""
DEPEND=""
S="${WORKDIR}/${SPN}_src/${PN}"

src_compile() {
   emake COUCH_SRC=../couchdb/src/couchdb
}

src_install() {
	# This component has a makefile, but the installation steps are in the
	# top-level makefile instead -____- These are the adapted installation
	# steps.
	mkdir -p ${D}/usr/lib/couchdb/plugins/geocouch/ebin
	cp -r ebin/* ${D}/usr/lib/couchdb/plugins/geocouch/ebin
	mkdir -p ${D}/etc/couchdb/default.d
	cp -r etc/couchdb/default.d/* ${D}/etc/couchdb/default.d
	mkdir -p ${D}/share/couchdb/www/script/test
	cp -r share/www/script/test/* ${D}/share/couchdb/www/script/test
}

pkg_postinst() {
	elog "For fresh ebuilds check https://github.com/elitak/couchbase-overlay"
	elog "Bugtracker https://github.com/elitak/couchbase-overlay/issues"
}
