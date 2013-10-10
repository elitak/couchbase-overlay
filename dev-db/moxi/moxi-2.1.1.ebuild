EAPI=5

DESCRIPTION="${PN} component of couchbase"
HOMEPAGE="https://www.couchbase.com"

SLOT="0"
SPN=couchbase-server
SPV=2.1.1
SRC_URI="http://packages.couchbase.com/releases/${SPV}/${SPN}_src-${SPV}.tar.gz"
LICENSE="COUCHBASE INC. COMMUNITY EDITION"
KEYWORDS="~x86 ~amd64"
IUSE=""

# FIXME
RDEPEND="
   =dev-db/libconflate-2.1.1
   =dev-db/libvbucket-1.1.1
   =dev-db/couchbase-memcached-2.1.1
   =dev-db/libmemcached-0.47
   "
DEPEND=""
S="${WORKDIR}/${SPN}_src/${PN}"

src_configure() {
   econf --without-check
}

pkg_postinst() {
	elog "For fresh ebuilds check https://github.com/elitak/couchbase-overlay"
	elog "Bugtracker https://github.com/elitak/couchbase-overlay/issues"
}
