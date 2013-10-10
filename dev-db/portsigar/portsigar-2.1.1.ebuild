EAPI=5

DESCRIPTION="${PN} from couchbase"
HOMEPAGE="https://www.couchbase.com"

SLOT="0"
SPN=couchbase-server
SRC_URI="http://packages.couchbase.com/releases/${PV}/${SPN}_src-${PV}.tar.gz"
LICENSE="COUCHBASE INC. COMMUNITY EDITION"
KEYWORDS="~x86 ~amd64"
IUSE=""

# FIXME
RDEPEND="
	=dev-libs/libsigar-1.6.2
"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${SPN}_src/${PN}"

pkg_postinst() {
	elog "For fresh ebuilds check https://github.com/elitak/couchbase-overlay"
	elog "Bugtracker https://github.com/elitak/couchbase-overlay/issues"
}
