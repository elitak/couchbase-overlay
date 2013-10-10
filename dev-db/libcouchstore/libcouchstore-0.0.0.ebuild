EAPI=5
inherit eutils

DESCRIPTION="libcouchstore from couchbase"
HOMEPAGE="https://www.couchbase.com"

SLOT="0"
SPN=couchbase-server
SPV=2.1.1
SRC_URI="http://packages.couchbase.com/releases/${SPV}/${SPN}_src-${SPV}.tar.gz"
LICENSE="COUCHBASE INC. COMMUNITY EDITION"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="
   =dev-db/libvbucket-1.1.1
   =dev-db/couchbase-memcached-0.0.0
   "
DEPEND=
#DEPEND="${RDEPEND}"

S="${WORKDIR}/${SPN}_src/${PV#lib}"

pkg_postinst() {
	elog "For fresh ebuilds check https://github.com/elitak/couchbase-overlay"
	elog "Bugtracker https://github.com/elitak/couchbase-overlay/issues"
}
